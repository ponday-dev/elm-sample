port module Counter exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)

main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model = Int


init : (Model, Cmd Msg)
init =
    (0, Cmd.none)


type Msg
    = Increment
    | Decrement
    | Suggest Int



port inc : Int -> Cmd msg
port dec : Int -> Cmd msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment ->
            (model, inc model)
        Decrement ->
            (model, dec model)
        Suggest suggestion ->
            (suggestion, Cmd.none)


port suggestions : (Int -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    suggestions Suggest


view : Model -> Html Msg
view model =
    div []
        [ button [onClick Decrement] [text "-"]
        , div [] [text (toString model)]
        , button [onClick Increment] [text "+"]
        ]

