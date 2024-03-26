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
  .password[1,1]:string
  .username[1,1]:string
}

type loginRequest:loginRequest

type logoutRequest:void {
  .username[0,1]:string
  .sid[1,1]:string
}

type logoutRequest:logoutRequest

type messagesRequest:void {
  .username[0,1]:string
  .sid[1,1]:string
}

type messagesRequest:messagesRequest

type prontoResponse:void {
  .Offer[0,1]:ASOffer
  .message[0,1]:string
  .sid[0,1]:string
}

type prontoResponse:prontoResponse

type registerRequest:void {
  .password[1,1]:string
  .surname[1,1]:string
  .name[1,1]:string
  .username[1,1]:string
}

type registerRequest:registerRequest

interface WebPortInterface {
RequestResponse:
  getMessages( messagesRequest )( undefined ),
  login( loginRequest )( prontoResponse ),
  logout( logoutRequest )( prontoResponse ),
  register( registerRequest )( prontoResponse )
}



outputPort WebPort {
  Protocol:http
  Location:"socket://localhost:8000"
  Interfaces:WebPortInterface
}


embedded { Jolie: "server.ol" in WebPort }
