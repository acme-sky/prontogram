type loginRequest:void {
  .password[1,1]:string
  .username[1,1]:string
}

type logoutRequest:void {
  .username[0,1]:string
  .sid[0,1]:string
}

type messagesRequest:void {
  .username[1,1]:string
  .sid[0,1]:string
}

type prontoResponse:void {
  .message[1,1]:string
  .sid[0,1]:string
}

type registerRequest:void {
  .password[1,1]:string
  .surname[1,1]:string
  .name[1,1]:string
  .username[1,1]:string
}

interface WebPortInterface {
RequestResponse:
  getMessages( messagesRequest )( undefined ),
  login( loginRequest )( prontoResponse ),
  logout( logoutRequest )( prontoResponse ),
  register( registerRequest )( prontoResponse )
}



outputPort WebPort {
  Protocol:http
  Location:"local"
  Interfaces:WebPortInterface
}


type incomingHeaderHandlerRequest:void {
  .headers[1,1]:undefined
  .operation[1,1]:string
}

type incomingHeaderHandlerResponse:undefined

type outgoingHeaderHandlerRequest:void {
  .response[0,1]:undefined
  .operation[1,1]:string
}

type outgoingHeaderHandlerResponse:undefined

interface HeaderPortInterface {
RequestResponse:
  incomingHeaderHandler( incomingHeaderHandlerRequest )( incomingHeaderHandlerResponse ),
  outgoingHeaderHandler( outgoingHeaderHandlerRequest )( outgoingHeaderHandlerResponse )
}



outputPort HeaderPort {
  Protocol:sodep
  Location:"local"
  Interfaces:HeaderPortInterface
}


embedded { Jolie: "server.ol" in WebPort }

embedded { Jolie: "RestHandler.ol" in HeaderPort }
