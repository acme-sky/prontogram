interface ProntoInterface{
    RequestResponse:
        //sendNotification(prontoMessage)(prontoResponse),
        //registrationRequest(prontoRequest)(prontoResponse),
        sendOffer(ASOffer)(prontoResponse),
        login(loginRequest)(prontoResponse)
}

// need user data to relate an offer
type ASOffer : void {
    .offerToker:       int
    .clientUsername:   string
    .customerName:     string
    .customerSurname:  string
    .DepartureLoc:     string
    .ArrivalLoc:       string
    .offerTimestamp:   string
    .offerDuration:    int //hours in int
    .DepartureTime:    string
    .OfferPrice:       double
    .IsLastMinute:     bool
    .IsValid:          bool
}


type loginRequest{
    .username: string
    .password: string
}


type messagesRequest{
    .username: string
    .sess_id?: string
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

