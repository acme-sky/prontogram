interface ProntoInterface{
    RequestResponse:
        sendNotification(prontoMessage)(prontoResponse),
        registrationRequest(prontoRequest)(prontoResponse),
        sendOffer(ASOffer)(prontoResponse),
        loginRequest(prontoRequest)(prontoResponse)
}


type ASOffer : void {
    .DepartureLoc:     string
    .ArrivalLoc:       string
    .DepartureTime:    string
    .OfferPrice:       double
    .IsLastMinute:     bool
    .IsValid:          bool
}

type prontoMessage :void{
    .text:  string
}

type prontoRequest :void{
    .text:  string
}

type prontoResponse :void{
    .text:  string
}

type User : void {
    username:       string
    password:       string
}


// register
// login
// getNotification

//sendNotification
