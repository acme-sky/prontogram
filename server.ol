include "pronto.iol"
include "console.iol"
include "string_utils.iol"
include "database.iol"

execution { concurrent }

service RestServer {

    inputPort WebPort{
        location: "socket://localhost:8000"
        protocol: http{
            .format = "json"
            .cookies.session = "sid"
            /*osc << {
                register << {
                    template = "/user/register"
                    method = "post"
                }
                login << {
                    template = "/user/login"
                    method = "post"
                }
                getMessages << {
                    template = "/getMessages/user"
                    method = "get"
                    
                }

            }*/
        }
        //protocol: sodep
        interfaces: ProntoInterface
    }

    cset {
        session: Session.sid prontoResponse.sid
    }

    init{

        install(
            SQLException => println@Console("Database error:" + sqlResponse.message )());
        keeprunning = true
        lock = 1

        with(dbconn){
            .username = "pronto"
            .password = "password"
            .host = "localhost"
            .database = "prontodb"
            .driver = "postgresql"
        }

        connect@Database(dbconn)(void)
        println@Console("connected to db")()
    }

    main{

        //login 
        [login(loginRequest)(prontoResponse){
            
            searchUserQuery = "SELECT * FROM users WHERE uname = '"+loginRequest.username+"' AND pw = '" + loginRequest.password+ "'"                
            searchUserQuery.username = loginRequest.username
            query@Database(searchUserQuery)(sqlResponse)
                //debug
                //println@Console("User found")()
                //handling user not found

            println@Console(sqlResponse.message)()

                //session token assignment
            sess_id = getRandomUUID@StringUtils()
                //debug
                //println@Console(sess_id)()

                //insert sessid token in response
                //prontoResponse.@headers["Set-Cookie"] = "sessionID=" + sess_id
                
            insertTokenQuery = "UPDATE users SET sess_id = '"+sess_id+"' WHERE uname = '"+loginRequest.username+"'"
                //debug
                //println@Console(insertTokenQuery)()
            update@Database(insertTokenQuery)(updateResponse)
                    
                    
                //feedback
            println@Console("User "+loginRequest.username+" logged in.")()
            prontoResponse.message = "Successful login"
            prontoResponse.sid = sess_id
        }]
        




        [getMessages(request)(response){            
            scope (getMessages)
            {
                install(SQLException => println@Console("Database error:" + sqlResponse.message )());
                    //get all offers for current user
                    valueToPrettyString@StringUtils(request)(res)
                    println@Console(res)()
                    //for every offer [cycle]
                    cookie = request.sid
                    println@Console(cookie)()
                    //get username from cookie
                    
                    //handle no username error
                                        
                    //messagesQuery = "select * from ASOffers where "
                    //offer[i].field = value

                    //response = array di offers / errore


            }
        }]     
    }

}