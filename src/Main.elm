module Main exposing (main)

import List
import Task
import Html exposing (Html, div)
import Html.Attributes
import Date exposing (Date)
import AnimationFrame exposing (times)
import Css exposing (..)


-- Types


type alias Model =
    Maybe Date


type Msg
    = RecvDate Date
    | Tick Float



-- Main program


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init =
    ( Nothing, Task.perform RecvDate Date.now )


update msg model =
    case msg of
        RecvDate date ->
            ( Just date, Cmd.none )

        Tick currentTime ->
            ( Just <| Date.fromTime currentTime, Cmd.none )


subscriptions model =
    times Tick


view model =
    div
        [ wrapperStyle ]
        [ Html.text <|
            case model of
                Just date ->
                    formatDate date

                Nothing ->
                    "??:??:??"
        ]



-- Utility


getValueAsString : Date -> (Date -> Int) -> String
getValueAsString date getter =
    toString <| getter date


formatDate date =
    let
        parts =
            [ Date.hour, Date.minute, Date.second ]

        values =
            List.map (getValueAsString date) parts

        padded =
            List.map (String.padLeft 2 '0') values
    in
        String.join ":" padded



-- Styling


styles =
    Css.asPairs >> Html.Attributes.style


wrapperStyle =
    styles
        [ width (vw 100)
        , height (vh 100)
        , fontSize (vw 12.5)
        , fontFamily monospace
        , textAlign center
        , lineHeight (vh 100)
        , color (hex "FFFFFF")
        , backgroundColor (hex "272822")
        ]
