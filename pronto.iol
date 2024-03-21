interface ProntoInterface{
    RequestResponse:
        //sendNotification(prontoMessage)(prontoResponse),
        //registrationRequest(prontoRequest)(prontoResponse),
        //sendOffer(ASOffer)(prontoResponse),
        login(loginRequest)(prontoResponse),
        getMessages(messagesRequest)(messagesResponse)
}

type Session: void{
    .sid: string
}

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
    //.username: string
    .sid?: string
}

type prontoMessage :void{
    .text:     string
    .offer:     ASOffer
}

type messagesResponse :void{
    userID?:     string
    offers[0,*]: prontoMessage
}

type prontoResponse :void{
    .message?:  string
    .Offer?:    ASOffer
    .sid:       string
}