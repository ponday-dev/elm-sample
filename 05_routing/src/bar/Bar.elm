module Bar exposing (..)

import Html exposing (..)


type Msg
    = UpdateMessage String


type alias Model =
    { msg: String
    }


init: (Model, Cmd Msg)
init =
    { msg = "" } ! []


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UpdateMessage message ->
            { model | msg = message } ! []


view: Model -> Html Msg
view model =
    div []
        [ text model.msg ]


subscriptions: Model -> Sub Msg
subscriptions model =
    Sub.none
