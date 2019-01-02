module TestUtils exposing (..)
import Fuzz exposing (Fuzzer, int, list, string, tuple)
import Model exposing (Color)
import Test exposing (..)
import Expect exposing (Expectation)
import Model exposing (..)

colors : List Color
colors = [
        Color 1 "yellow" "yellow",
        Color 2 "green" "green",
        Color 3 "red" "red",
        Color 4 "cyan" "cyan"
    ]

fuzzColors : String -> ((List Color)->Expectation ) -> Test
fuzzColors testDescription exp = 
    test testDescription (\list -> exp colors )

fuzzColorsAndSelected : String -> (List Color-> Color->Expectation ) -> Test
fuzzColorsAndSelected testDescription exp = fuzzColors testDescription 
    (\colorList -> 
        let maybeColor = List.head colorList
            firstColor = case maybeColor of
                        Just c -> c
                        Nothing -> voidColor
        in firstColor
        |> (\color-> (exp colorList color) )
    )