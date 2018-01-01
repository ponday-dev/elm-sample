module Main exposing (..)

import Html exposing (..)
import Navigation exposing (Location)
import Routing exposing (Route, parseLocation)
import Foo
import Bar


main: Program Never Model Msg
main =
    Navigation.program LocationChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { route: Route
    , barModel: Bar.Model
    }


initialModel: Route -> Model
initialModel route =
    { route = route
    , barModel = { msg = "" }
    }


init: Location -> (Model, Cmd Msg)
init location =
    (initialModel <| Routing.parseLocation location) ! []


type Msg
    = LocationChange Location
    | FooMsg Foo.Msg
    | BarMsg Bar.Msg


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FooMsg msg ->
            model ! []
        BarMsg msg ->
            let
                (barModel, cmd) =
                    Bar.update msg model.barModel
            in
                { model | barModel = barModel } ! [Cmd.map BarMsg cmd] 
        LocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                { model | route = newRoute } ! []


view: Model -> Html Msg
view model =
    div []
        [page model]


subscriptions: Model -> Sub Msg
subscriptions model =
    Sub.none


page: Model -> Html Msg
page model =
    case model.route of
        Routing.FooRoute ->
            Html.map FooMsg Foo.view
        Routing.BarRoute msg ->
            let
                m =
                    model.barModel
                newModel =
                    { m | msg = msg }
            in
                Html.map BarMsg (Bar.view newModel)
        Routing.NotFoundRoute ->
            div [] [text "404"]
