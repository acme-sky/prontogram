type ASOffer:void {
  .customerSurname[1,1]:string
  .DepartureTime[1,1]:string
  .DepartureLoc[1,1]:string
  .clientUsername[1,1]:string
  .offerToken[1,1]:int
  .offerDuration[1,1]:int
  .offerTimestamp[1,1]:string
  .OfferPrice[1,1]:double
  .customerName[1,1]:string
  .IsLastMinute[1,1]:bool
  .ArrivalLoc[1,1]:string
  .IsValid[1,1]:bool
}

type loginRequest:void {
  .password[0,1]:string
  .username[0,1]:string
  .sid[0,1]:string
}

type logoutRequest:void {
  .username[0,1]:string
  .sid[0,1]:string
}

type messagesRequest:void {
  .username[0,1]:string
  .sid[0,1]:string
}

type prontoResponse:void {
  .Offer[0,1]:ASOffer
  .message[0,1]:string
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
