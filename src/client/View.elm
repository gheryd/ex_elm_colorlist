module View exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Html.Events exposing (onClick)

view : Model -> Html Msg
view model = 
    div [class "container"] [
        nav [][
            div [class "nav-wrapper"] [
                a [class "brand-logo"] [text "Color List"]
                ,a [
                        href "#" 
                        , attribute "data-target" "sideMenu" 
                        , class "sidenav-trigger"
                    ][
                        i [class "material-icons"] [text "menu" ]
                    ]
                ,ul [class "right hide-on-med-and-down"] menuItems
            ]
        ]
        ,ul [class "sidenav", id "sideMenu"] menuItems     
        ,div [class "card"][
            div [
                style "backgroundColor" model.selected.color,
                class "card-content white-text"
            ]
            [
                span [class "card-title"][text "preview"]
                ,text model.selected.name
            ]
        ]
        ,(case model.status of
            Loaded colors -> createItems colors model.selected
            Loading -> loading
            Errored error -> creatingError error
        )
    ]

menuItems : List (Html Msg)
menuItems = [
        li  [] [ a[ onClick ResetSelection] [text "restore"] ]
        ,li [] [ a [onClick SelectRandomColor] [text "select random"] ]
        ,li [] [ a [onClick ReloadColors] [text "reload colors"] ]
    ]

loading : Html Msg
loading  = div [class ""] [ span [] [text "loading..."] ]

creatingError : String -> Html Msg
creatingError error = div [class ""] [ span [] [text ("Error: "++error)] ]

createItems: List Color -> Color -> Html Msg
createItems colors selected = 
    div 
        [class "collection"]
        ( List.map (\color->createItem color selected ) colors)

createItem : Color -> Color -> Html Msg
createItem color currentColor = 
    a
        [
            class ("collection-item"++(if color==currentColor then " active" else ""))
            ,onClick (SelectColor color)
        ]
        [
            span 
                [
                    class "badge"
                    ,style "color" color.color
                    ,style "backgroundColor" color.color
                ]
                [
                    text "preview"
                ]
            ,text color.name
        ]