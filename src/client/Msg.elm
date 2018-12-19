module Msg exposing (..)
import Http
import Model exposing (..)

type alias HttpResult = Result Http.Error (List Color)

type Msg
    = GotColors HttpResult
    | SelectColor Color
    | ReloadColors
    | ResetSelection
    | SelectRandomColor
    | GetRandomColor (Maybe Color, List Color)