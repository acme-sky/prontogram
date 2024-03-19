include "pronto.iol"
include "console.iol"
include "string_utils.iol"
include "database.iol"

//execution { concurrent }

service RestServer {

    inputPort WebPort{
        location: "socket://localhost:8000"
        protocol: http{
            format = "json"
            osc << {
                register << {
                    template = "/user/register"
                    method = "post"
                }
                login << {
                    template = "/user/login"
                    method = "post"
                }
                getMessages << {
                    template = "/getMessages"
                    method = "get"
                    
                }

            }
        }
        interfaces: ProntoInterface
    }

    cset {
        //sid = prontoRequest.sid
    }

    init{

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
        
        scope(login) {
            install(
                SQLException => println@Console("Database error:" + sqlResponse.message )());

                //login 
                login(loginRequest)(prontoResponse){
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
                    insertTokenQuery = "UPDATE users SET sess_id = '"+sess_id+"' WHERE uname = '"+loginRequest.username+"'"
                    //debug
                    //println@Console(insertTokenQuery)()
                    update@Database(insertTokenQuery)(updateResponse)
                    
                    //feedback
                    println@Console("User "+loginRequest.username+" logged in.")()
                    prontoResponse.message = "Successful login"
            }
        }

        scope (getMessages)
        {
             install(
                SQLException => println@Console("Database error:" + sqlResponse.message )());



                getMessages(request)(response){
                    
                    //get all offers for current user
                    
                    //for every offer [cycle]

                    //offer[i].field = value

                    //response = array di offers / errore


                }     
        }










    }
}