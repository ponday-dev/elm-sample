import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)

-- entry point

main =
  Html.beginnerProgram { model = state, view = view, update = action }


-- state definition

type alias State =
  { counter: Int
  }
state : State
state =
  { counter = 0
  }


-- message

type Msg = Increment | Decrement | Reset


-- action

action : Msg -> State -> State
action msg state =
  case msg of
    Increment ->
      { state | counter = state.counter + 1 }
    Decrement ->
      { state | counter = state.counter - 1 }
    Reset ->
      { state | counter = 0 }


-- view

view : State -> Html Msg
view state =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString state.counter) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "reset" ]
    ]