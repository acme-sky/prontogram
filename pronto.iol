
/*if needed for offers manipulation
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
}*/


type loginRequest{
    .username: string
    .password: string
    .headers?:  undefined
    //.sid?:     string
}

type logoutRequest{
    .username?: string
    .sid?:      string
}

type registerRequest{
    .username: string
    .password: string
    .name:     string
    .surname:  string
}

type messagesRequest{
    .username: string
    .sid?:      string
}

type prontoResponse :void{
    .message:  string
    .sid?:       string
}

type options_type :void{
    message?:   string
    values:     undefined
}

interface ProntoInterface{
    RequestResponse:
        login(loginRequest)(prontoResponse),
        getMessages(messagesRequest)(undefined),
        register(registerRequest)(prontoResponse),
        logout(logoutRequest)(prontoResponse),
        login_options(options_type)(options_type)
}