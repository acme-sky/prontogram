interface ProntoInterface{
    RequestResponse:
        sendNotification(prontoMessage)(prontoResponse)
        registrationRequest(prontoRequest)(prontoResponse)
        sendOffer(ASOffer)(prontoResponse)
        loginRequest(prontoRequest)(prontoResponse)
}


type ASOffer{
    .DepartureLoc:     string
    .ArrivalLoc:       string
    .DepartureTime:    string
    .OfferPrice:       double
    .IsLastMinute:?    bool
    .IsValid:          bool
}


type User{
    username:       string
    password:       string
}


// register
// login
// getNotification

//sendNotification
