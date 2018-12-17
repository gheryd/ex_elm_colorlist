module Test exposing (main)
import Html exposing (Html, div, text, button, ul, li, a, nav, span)
import Html.Attributes exposing (classList, class, style)
import Html.Events exposing (onClick)
import Browser
import Random
import Random.List

type alias Item = {id:Int, value:String, color:String}

type alias Model = {
    color: String,
    list: List Item, 
    selected:Item
    }

type Msg = 
        SelectItem Item 
        | GetRandomItem (Maybe Item, List Item)
        | Restore
        | SelectRandomItem

voidItem = {id=-1, value="", color="blue"}

initModel : Model
initModel = {
        color = voidItem.color
        ,list = [
            {id= 1, value="green", color="green"},
            {id= 2, value="brown", color="brown"},
            {id= 3, value="red", color="red"}
            ,{id= 4, value="cyan", color="cyan"}
            ,{id= 5, value="chartreuse", color="chartreuse"}
            ,{id= 6, value="violet", color="violet"}
            ,{id= 7, value="aquamarine", color="aquamarine"}
        ]
        ,selected = voidItem
    }

view : Model -> Html Msg
view model = 
    div [ class "container" ]
        [
            nav [] [
                div [class "nav-wrapper"] [
                    a [class "brand-logo"] [text "Color List"]
                    ,ul [class "right hide-on-med-and-down"][
                        li  [] [
                            a[
                                onClick Restore] [text "restore"
                            ] 
                        ]
                        , li [] [
                                a [
                                    onClick SelectRandomItem
                                ] [text "select random"]
                        ]
                    ]
                ]
            ]           
            , div [class "card blue-grey darken-1"][
                div [
                    style "backgroundColor" model.selected.color,
                    class "card-content white-text"
                ]
                [
                    span [class "card-title"][text "preview"]
                    ,text model.selected.color
                ] 
            ]
            ,(createItems model)
                
        ]

createItems : Model -> Html Msg
createItems model = div [class "collection"] 
    (List.map (\v -> createItem v model.selected ) model.list)

createItem : Item -> Item -> Html Msg
createItem item currentItem = a [
        class ("collection-item"++(if item.value==currentItem.value then " active" else "" ) )
        ,onClick (SelectItem item)
    ] [
        span [class "badge", 
            style "color" item.color
            ,style "backgroundColor" item.color] 
            [text "preview"]
        ,text item.value
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        GetRandomItem (maybeItem, newList) -> 
                case maybeItem of
                    Nothing -> ({model|selected=voidItem}, Cmd.none)
                    Just item -> ({model|selected=item}, Cmd.none)
        SelectItem item-> ({model| selected=item}, Cmd.none)
        Restore -> ({model| selected=voidItem}, Cmd.none)
        SelectRandomItem -> (model, 
                Random.generate GetRandomItem (Random.List.choose model.list)
            )

main : Program () Model Msg
main = Browser.element {
        init = \flags -> (initModel, Cmd.none)
        ,view = view
        ,update = update
        ,subscriptions = \mode -> Sub.none
    }