module Main exposing (main)

import List
import Task
import Html exposing (Html, div)
import Html.Attributes
import Html.Lazy exposing (lazy)
import Date exposing (Date)
import AnimationFrame exposing (times)
import Css exposing (..)


-- Types


type alias Model =
    String


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
    ( "??:??:??", Task.perform RecvDate Date.now )


update msg model =
    case msg of
        RecvDate date ->
            ( getNewModel model date, Cmd.none )

        Tick currentTime ->
            ( getNewModel model <| Date.fromTime currentTime, Cmd.none )


{-| Used to preserve referential equality
-}
getNewModel oldModel date =
    let
        formatted =
            formatDate date
    in
        if formatted == oldModel then
            oldModel
        else
            formatted


subscriptions model =
    times Tick


view model =
    lazy realView model


realView model =
    div
        [ wrapperStyle ]
        [ Html.text model ]



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
