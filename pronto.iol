interface ProntoInterface{
    RequestResponse:
        //sendNotification(prontoMessage)(prontoResponse),
        //registrationRequest(prontoRequest)(prontoResponse),
        sendOffer(ASOffer)(prontoResponse),
        login(loginRequest)(prontoResponse)
}

// need user data to relate an offer
type ASOffer : void {
    .customerName:     string
    .customerSurname:  string
    .DepartureLoc:     string
    .ArrivalLoc:       string
    .DepartureTime:    string
    .OfferPrice:       double
    .IsLastMinute:     bool
    .IsValid:          bool
}


type loginRequest{
    .username: string
    .password: string
}

type prontoMessage :void{
    .text:     string
    .offer:     ASOffer
}

type prontoRequest :void{
    .message:  string
    .sid:   string
    .type:  string
}

type prontoResponse :void{
    .message?:  string
    .Offer?: ASOffer
    .sid?:   string
}


type User : void {
    .name:           string
    .surname:        string
    .username:       string
    .password:       string
}

