module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, int, string, succeed)
import Json.Decode.Pipeline exposing (requiredAt, optionalAt)
import String exposing (toInt)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { user : Maybe User
    , id: Int
    , message : String
    }


type alias User =
    { id : Int
    , name : String
    , email : String
    }


type Msg
    = GetUser Int
    | GotUser (Result Http.Error User)
    | ChangeInput String


init : ( Model, Cmd Msg )
init =
    ( { user = Nothing, id = 0, message = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeInput id ->
            ( { model | id = (Result.withDefault 0 (toInt id)) }, Cmd.none)
        GetUser id ->
            ( { model | message = "fetching user..." }, getUser id )

        GotUser (Ok user) ->
            ( { model | user = Just user, message = "" }, Cmd.none )

        GotUser (Err e) ->
            ( { model | user = Nothing, message = "fetching user failed" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "number", onInput ChangeInput] []
        , button [ onClick (GetUser model.id) ] [text "get user data"]
        , div [] [text model.message]
        , div []
            [ userView model.user
            ]
        ]


userView : Maybe User -> Html Msg
userView user =
    case user of
        Just u ->
            div []
                [ div [] [ text ("id: " ++ (toString u.id)) ]
                , div [] [ text ("name:" ++ u.name) ]
                , div [] [ text ("email:" ++ u.email) ]
                ]

        Nothing ->
            div [] []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getUser : Int -> Cmd Msg
getUser id =
    let
        url =
            endpoint ++ (toString id)

        request =
            Http.get url userDecoder
    in
        Http.send GotUser request


userDecoder : Decoder User
userDecoder =
    succeed User
        |> requiredAt [ "id" ] int
        |> requiredAt [ "name" ] string
        |> optionalAt [ "email" ] string ""


endpoint : String
endpoint =
    "http://localhost:3000/users/"
