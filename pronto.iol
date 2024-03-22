interface ProntoInterface{
    RequestResponse:
        login(loginRequest)(prontoResponse),
        getMessages(messagesRequest)(undefined)
}

type Session: void{
    .sid: string
}

type ASOffer : void {
    .offerToken:       int
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
    .username?: string
    .sid?: string
}

type messagesResponse :void{
    userID?:     string
    offers[0,*]: ASOffer
}

type prontoResponse :void{
    .message?:  string
    .Offer?:    ASOffer
    .sid?:       string
}