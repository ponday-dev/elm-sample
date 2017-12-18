import Html exposing (..)

import Json.Decode as Decode

main: Html Msg
main =
    mapToHtml sampleJson


type alias User =
    { id: Int
    , name: String
    , email: String
    }


mapToHtml: String -> (Html Msg)
mapToHtml jsonText =
    let
        result =
            decodeUser jsonText
    in
        case result of
            Ok user ->
                div []
                    [ div [] [text (toString user.id)]
                    , div [] [text user.name]
                    , div [] [text user.email]
                    ]
            Err e ->
                div [] [text e]


type Msg = Noop


decodeUser: String -> (Result String User)
decodeUser jsonText =
    Decode.decodeString userDecoder jsonText


userDecoder: Decode.Decoder User
userDecoder =
    Decode.map3 User
        (Decode.at ["id"] Decode.int)
        (Decode.at ["name"] Decode.string)
        (Decode.at ["email"] Decode.string)


sampleJson: String
sampleJson =
    """{ "id": 1, "name": "sample", "email": "foobar@sample.com"}"""
