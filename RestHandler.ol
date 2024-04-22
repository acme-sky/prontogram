include "console.iol"
include "json_utils.iol"

type incomingHeaderHandlerRequest:void{
    .operation:string 
    .headers:undefined
}
type incomingHeaderHandlerResponse: undefined

type outgoingHeaderHandlerRequest:void{
    .operation:string 
    .response?:undefined
}

type outgoingHeaderHandlerResponse: undefined

interface HeaderHandlerInterface{
    RequestResponse:
    incomingHeaderHandler(incomingHeaderHandlerRequest)(incomingHeaderHandlerResponse),
    outgoingHeaderHandler(outgoingHeaderHandlerRequest)(outgoingHeaderHandlerResponse)
}
inputPort HeaderPort {
        Protocol:sodep
        Location:"local"
        Interfaces:HeaderHandlerInterface
}

execution { concurrent }
main{
    [incomingHeaderHandler(request)(response){
        if ( request.operation == "api/login" ){
            getJsonValue@JsonUtils(request.headers.("data"))(credentials)
            response.username = credentials.username
            response.password = credentials.password
        } else if (request.operation == "api/register") {
            getJsonValue@JsonUtils(request.headers.("data"))(credentials)
            response.username = credentials.username
            response.password = credentials.password
            response.name = credentials.name
            response.surname = credentials.surname
        } else if (request.operation == "getMessages" || request.operation == "logout"){
                response.sid = request.headers.cookies.session
            }
    }]

    [outgoingHeaderHandler(request)(response){
        response.("Access-Control-Allow-Methods") = "POST,GET,DELETE,PUT,OPTIONS"
        response.("Access-Control-Allow-Origin") = "*"
        response.("Access-Control-Allow-Headers") = "Content-Type, Authorization"
        if(request.operation == "login"){
            response.("Set-Cookie") = "session="+request.response.sid
        }
    }]
}