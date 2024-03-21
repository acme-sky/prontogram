type ASOffer:void {
  .customerSurname[1,1]:string
  .DepartureTime[1,1]:string
  .DepartureLoc[1,1]:string
  .offerToker[1,1]:int
  .clientUsername[1,1]:string
  .offerDuration[1,1]:int
  .offerTimestamp[1,1]:string
  .OfferPrice[1,1]:double
  .customerName[1,1]:string
  .IsLastMinute[1,1]:bool
  .ArrivalLoc[1,1]:string
  .IsValid[1,1]:bool
}

type loginRequest:void {
  .password[1,1]:string
  .username[1,1]:string
}

type loginRequest:loginRequest

type messagesRequest:void {
  .sess_id[0,1]:string
  .username[1,1]:string
}

type messagesRequest:messagesRequest

type messagesResponse:void {
  .offers[0,*]:prontoMessage
  .userID[1,1]:string
}

type messagesResponse:messagesResponse

type prontoMessage:void {
  .offer[1,1]:ASOffer
  .text[1,1]:string
}

type prontoResponse:void {
  .Offer[0,1]:ASOffer
  .message[0,1]:string
  .sid[1,1]:string
}

type prontoResponse:prontoResponse

interface WebPortInterface {
RequestResponse:
  getMessages( messagesRequest )( messagesResponse ),
  login( loginRequest )( prontoResponse )
}



outputPort WebPort {
  Protocol:http
  Location:"socket://localhost:8000"
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
