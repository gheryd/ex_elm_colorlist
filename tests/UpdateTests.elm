module UpdateTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string, tuple)
import Test exposing (..)

import Main exposing (update)
import Model exposing (..)
import Msg exposing (..)
import Array

updateColors : Test
updateColors = 
    describe "msg colors" [
        test "Realod colors and selected is voidColor"
            (\_ -> 
                initModel
                    |> update ReloadColors 
                    |> Tuple.first
                    |> .selected
                    |> Expect.equal (voidColor)
                
            )
        ,fuzz (list (tuple (int,string))) "check GotColors message" 
            (\list ->
                List.map (\(id, color)-> Color id color color) list
                |> \colors -> update (GotColors (Ok colors)) initModel
                |> Tuple.first
                |> Expect.equal {initModel| status=Loaded (colors)}
            )
    ]