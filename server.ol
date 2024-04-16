include "pronto.iol"
include "console.iol"
include "string_utils.iol"
include "database.iol"
include "time.iol"

execution { concurrent }

service RestServer {

    inputPort WebPort{
        location: "local"
        protocol: http{
            .format = "json"
            .cookies.session = "sid"
            //TODO cookies-duration
        }
        interfaces: ProntoInterface
    }

    cset {
        session: prontoResponse.sid logoutRequest.sid messagesRequest.sid
    }

    init{

        install(
            ConnectionError => println@Console("Connection error.")()
        );

        //TODO parametric connection with .env 
        with(dbconn){
            .username = "pronto"
            .password = "password"
            .host = "localhost"
            .database = "prontodb"
            .driver = "postgresql"
        }

        connect@Database(dbconn)(void)
        println@Console("Connected to db " +dbconn.database)()
    }

    main{
        


        [login(loginRequest)(prontoResponse){
            scope (login) {
                install (NoUserFound => println@Console("User not found.")()
                        prontoResponse.status = 1);

            searchUserQuery = "SELECT * FROM users WHERE uname = '"+loginRequest.username+"' AND pw = '" + loginRequest.password+ "'"
              
            query@Database(searchUserQuery)(sqlResponse)
            
            //handling user not found
            if(#sqlResponse.row == 0){
                prontoResponse.message = "Wrong credentials. Please check username and password" 
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
                    NoCookieException => println@Console("User is not authenticated")());
                    

                    //get username from cookie
                    cookie = request.sid
                    //usable
                    uname = global.users.(cookie).username

                    //we need this for the openapi specification
                    //uname = request.username
                    if(cookie = ""){
                        response.message = "User is not authenticated. Please login."
                        throw (NoCookieException)
                    }else{
                        //messagesQuery = "SELECT * FROM ASOffers WHERE client_username = '"+uname+"'" 
                        messagesQuery = "SELECT * FROM messages WHERE username = '"+uname+"'"
                        query@Database(messagesQuery)(sqlResponse)

                        response.messages -> sqlResponse.row

                        /*can be used to map offers to an offer structure if needed
                        for(element in sqlResponse.row){
                            valueToPrettyString@StringUtils(element)(res)
                            println@Console(res)()
                        }*/
                    }
            }
        }]


        //works with form data passed as body 
        [register (request)(response) {
            
            scope(register){
                install(
                    SQLException => println@Console("Database error:" )(),
                    UsernameNotAvailableException => println@Console("Username not available")()
                            response.status = 1);

                    queryCheck = "SELECT * FROM users WHERE uname ='"+request.username+"'"
                    query@Database(queryCheck)(checkResponse)
                    if(#checkResponse.row != 0){
                        response.message = "Username not available."
                        throw (UsernameNotAvailableException)
                    }else{
                        registerQuery = "INSERT INTO users VALUES (:username, :password, :name, :surname)"
                        registerQuery.username = request.username
                        registerQuery.password = request.password
                        registerQuery.name = request.name
                        registerQuery.surname = request.surname
                        update@Database(registerQuery)(ret)
                        if(ret == 0){
                            response.message = "Registration failed. Please Try again"
                            throw(SQLException)
                        }

                        response.message = "User "+request.username+" registered correctly"
                    }
            }
        }]     


        [logout (request)(response){
            scope(logout){
                install(
                    SQLException => println@Console("Database error" )(),
                    UserNotFoundException => println@Console("User "+request.username+" not found.")()
                            response.status = 1);
                
                uname = global.users.(request.sid).username
                logoutQuery = "UPDATE users SET sess_id = NULL where uname = '"+uname+"'"
                update@Database(logoutQuery)(result)

                if(result == 0) {
                    response.message = "Logout failed. Please check username"
                } else {
                    response.message = "Logout successful"
                    global.users.(request.sid) = void
                 }
            }
        }]
    
        [sendMessage(request)(response) {
            scope(send){
                install(
                    SQLException => response.message="Database error:" ,
                    UserNotFoundException => response.message="User "+request.username+" not found."
                            response.status = 1);

                queryCheck = "SELECT * FROM users WHERE uname ='"+request.username+"'"
                query@Database(queryCheck)(checkResponse)
                if(#checkResponse.row == 0){
                    response.message = "Username not available."
                    throw (UsernameNotFoundException)
                }else{
                    expiration_timestamp = request.expiration
                    expiration_timestamp.format = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    getTimestampFromString@Time(expiration_timestamp)(timestamp)//2024-03-02T13:10:00Z
                    insertQuery = "INSERT INTO messages VALUES (:message ,:username, :expiration)"
                    insertQuery.message = request.message
                    insertQuery.username = request.username
                    insertQuery.expiration = timestamp
                    update@Database(insertQuery)(ret)
                    if(ret == 0){
                        throw(SQLException)
                    }
                    response.message = "Message sent"
                }
            }
        }]
    }
 

}