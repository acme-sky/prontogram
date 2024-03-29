include "console.iol"
include "string_utils.iol"
include "converter.iol"

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
        if ( request.operation == "login" ){//|| request.operation == "getMessages" || request.operation == "logout") {
            //get encoded credentials
            splitReq = request.headers.("authorization")
            splitReq.regex = " "
            split@StringUtils(splitReq)(credentials)
            //decode credentials
            base64ToRaw@Converter(credentials.result[1])(decodedCred)
            rawToString@Converter(decodedCred)(decodedString)
            splitReq2 = decodedString
            splitReq2.regex = ":"
            split@StringUtils(splitReq2)(decodedCredentials)
            response.username = decodedCredentials.result[0]
            response.password = decodedCredentials.result[1]
        } else if (request.operation == "getMessages" || request.operation == "logout"){
                response.sid = request.headers.cookies.session
                valueToPrettyString@StringUtils(response)(res)
                println@Console(res)()
            }
    }]

    [outgoingHeaderHandler(request)(response){
        response.("Access-Control-Allow-Methods") = "POST,GET,DELETE,PUT,OPTIONS"
        response.("Access-Control-Allow-Origin") = "*"
        response.("Access-Control-Allow-Headers") = "Content-Type"
        if(request.operation == "login"){
            response.("Set-Cookie") = "session="+request.response.sid
        }
    }]
}