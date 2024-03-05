include "pronto.iol"
include "console.iol"
include "string_utils.iol"

execution { concurrent }

//service RestServer {

    inputPort WebPort{
        location: "socket://localhost:8000"
        protocol: http{
            format = "json"
            osc << {
                register << {
                    template = "/user/register"
                    method = "post"
                }
                login << {
                    template = "/user/login"
                    method = "post"
                }
            }
        }
        interfaces: ProntoInterface
    }