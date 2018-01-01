module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (Parser, parseHash, oneOf, map, top, s, string, (</>) )

type Route
    = FooRoute
    | BarRoute String
    | NotFoundRoute


matchers: Parser (Route -> a) a
matchers =
    oneOf
        [ map FooRoute top
        , map FooRoute (s "foo")
        , map BarRoute (s "bar" </> string)
        ]


parseLocation: Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route
        Nothing ->
            NotFoundRoute

