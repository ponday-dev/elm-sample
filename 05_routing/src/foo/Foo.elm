module Foo exposing (..)

import Html exposing (Html, div, text)

type Msg = Noop

view: Html Msg
view =
    div [] [text "Foo page"]
