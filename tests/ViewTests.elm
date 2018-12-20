module ViewTests exposing (..)
import Test exposing (..)
import Expect exposing (Expectation)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, attribute, classes, containing)
import Test.Html.Event as Event
import Html.Attributes as Attr
import Model exposing (..)
import View exposing (view)
import TestUtils  exposing (..)
import Msg exposing (..)

showLoading: Test
showLoading = 
    test "show loading" <|
        \_ -> 
            initModel
            |> view
            |> Query.fromHtml
            |> Query.find [attribute (Attr.class "progress")]
            |> Query.has [tag "div", classes ["progress"]]

showColors: Test
showColors = fuzzColors "show colors" 
    (\colors ->
        {initModel| status=Loaded colors}
            |> view
            |> Query.fromHtml
            |> Query.findAll [attribute (Attr.class "collection-item"), tag "a" ]
            |>Query.count (Expect.equal (List.length colors))
    )


showSelected = fuzzColorsAndSelected "show selected"
    (\colors selectedColor ->
        {initModel| status=Loaded colors, selected=selectedColor} 
        |> view
        |> Query.fromHtml
        |> Query.find [classes["card-content"]]
        |> Query.has [attribute (Attr.style "backgroundColor" selectedColor.color)]
        
    )
showSelectedOnClick = fuzzColorsAndSelected "show selected on click"
    (\colors color ->
        {initModel| status=Loaded colors}
        |> view
        |> Query.fromHtml
        |> Query.find [
                attribute (Attr.class "collection-item")
                , tag "a"
                ,containing  [
                    attribute (Attr.style "backgroundColor" color.color)
                    , tag "span"
                    ]
            ]
        |> Event.simulate Event.click
        |> Event.expect (SelectColor color)
    )