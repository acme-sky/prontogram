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
            ConnectionError => println@Console("Connection error.")()
        );
        
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
        


        [login(loginRequest)(prontoResponse){
            scope (login) {
                install (NoUserFound => println@Console("User not found.")());
            searchUserQuery = "SELECT * FROM users WHERE uname = '"+loginRequest.username+"' AND pw = '" + loginRequest.password+ "'"                

            query@Database(searchUserQuery)(sqlResponse)
            
            //handling user not found
            if(#sqlResponse.row == 0){
                prontoResponse.message = "User "+loginRequest.username+" not found."
                throw (NoUserFound)
            }else {
                sess_id = getRandomUUID@StringUtils()

                insertTokenQuery = "UPDATE users SET sess_id = '"+sess_id+"' WHERE uname = '"+loginRequest.username+"'"
                update@Database(insertTokenQuery)(updateResponse)

                //adds user to the global user registered array                    
                global.users.(sess_id).username = loginRequest.username

                println@Console("User "+loginRequest.username+" logged in.")()
                prontoResponse.message = "Successful login"
                prontoResponse.sid = sess_id
                
            }
            }
        }]
        




        [getMessages(request)(response){            
            scope (getMessages)
            {
                install(
                    SQLException => println@Console("Database error:" )(),
                    NoCookie => println@Console("User is not authenticated")());

                    //get username from cookie
                    cookie = request.sid
                    uname = global.users.(cookie).username

                    if(!cookie){
                        response.message = "User is not authenticated. Please login."
                        throw (NoCookie)
                    }else{
                        messagesQuery = "SELECT * FROM ASOffers WHERE client_username = '"+uname+"'" 
                        println@Console(messagesQuery)()
                        query@Database(messagesQuery)(sqlResponse)

                        response.offers -> sqlResponse.row

                        /*can be used to map offers to an offer structure if needed
                        for(element in sqlResponse.row){
                            valueToPrettyString@StringUtils(element)(res)
                            println@Console(res)()
                        }*/

                        //handle no username error
                    }
            }
        }]

        [register (request)(response) {

            queryCheck = "SELECT * FROM users WHERE username ='"+request.username+"'"
            query@Database(queryCheck)(checkResponse)
            //user already registered error


            //register new user
            //insert query
            //feedback 


        }]     




        //logout
        //clear sessid
    }

}