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
            //TODO cookies-duration
        }
        interfaces: ProntoInterface
    }

    cset {
        session: Session.sid prontoResponse.sid
    }

    init{

        install(
            SQLException => println@Console("Database error:" + sqlResponse.row[0] )());
        keeprunning = true
        

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
            //searchUserQuery.username = loginRequest.username
            query@Database(searchUserQuery)(sqlResponse)
                //handling user not found

            println@Console(sqlResponse.message)()

            //session token assignment
            sess_id = getRandomUUID@StringUtils()

            insertTokenQuery = "UPDATE users SET sess_id = '"+sess_id+"' WHERE uname = '"+loginRequest.username+"'"
            update@Database(insertTokenQuery)(updateResponse)

            //adds user to the global user registered array                    
            global.users.(sess_id).username = loginRequest.username

            println@Console("User "+loginRequest.username+" logged in.")()
            prontoResponse.message = "Successful login"
            prontoResponse.sid = sess_id
        }]
        




        [getMessages(request)(response){            
            scope (getMessages)
            {
                install(SQLException => println@Console("Database error:" + sqlResponse.row[0] )());

                    //get username from cookie
                    cookie = request.sid
                    username = global.users.(cookie).username
                    //debug
                    //println@Console(cookie)()
                    messagesQuery = "SELECT * FROM ASOffers WHERE client_username = '"+username+"'" 
                    println@Console(messagesQuery)()
                    query@Database(messagesQuery)(sqlResponse)
                    //working
                    //response.values -> sqlResponse.row
                    response.offers -> sqlResponse.row
                    /*can be used to map offers to an offer structure if needed
                    for(element in sqlResponse.row){
                        valueToPrettyString@StringUtils(element)(res)
                        println@Console(res)()
                    }*/

                    //handle no username error

                    //response = array di offers / errore


            }
        }]     
    }

}