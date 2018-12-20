module Main exposing (..)
import Http 
import Model exposing (..)
import View exposing (view)
import Msg exposing (..)
import Browser
import Json.Decode exposing (Decoder, field, string, int)
import Random
import Random.List

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        GotColors (Ok colors) -> ({model| status=Loaded colors}, Cmd.none)
        GotColors (Err httpError) -> ({model| status=getHttpMessageError httpError}, Cmd.none)
        SelectColor color -> ({model | selected=color}, Cmd.none)
        ReloadColors -> ({model| status=Loading, selected=voidColor}, loadColors)
        ResetSelection -> ({model| selected=voidColor}, Cmd.none)
        SelectRandomColor -> case model.status of
            Loaded colors -> (model, Random.generate GetRandomColor (Random.List.choose colors) )
            _ -> (model, Cmd.none)
        GetRandomColor (maybeColor, newList) -> 
            case maybeColor of
                Nothing -> ({model|selected=voidColor}, Cmd.none)
                Just color -> ({model|selected=color}, Cmd.none)

getHttpMessageError : Http.Error -> Status
getHttpMessageError httpError = 
    case httpError of
        Http.BadUrl str -> Errored str
        Http.Timeout -> Errored "timeout"
        Http.NetworkError -> Errored "network error"
        Http.BadStatus st -> Errored ("bad status: "++(String.fromInt st))
        Http.BadBody str -> Errored str

loadColors : Cmd Msg
loadColors = Http.get 
    {
        url = "http://localhost:3000/api/colors"
        ,expect = Http.expectJson GotColors colorsDecoder
    }

init : () -> (Model, Cmd Msg)
init _ = ( initModel, loadColors )

colorDecoder : Decoder Color
colorDecoder = Json.Decode.map3 Color 
    (field "id" int) 
    (field "color" string)
    (field "name" string)
colorsDecoder: Decoder (List Color)
colorsDecoder = Json.Decode.list colorDecoder

main : Program () Model Msg
main = Browser.element
    {
        init = init
        ,view = view
        ,update = update
        ,subscriptions = \mode -> Sub.none
    }