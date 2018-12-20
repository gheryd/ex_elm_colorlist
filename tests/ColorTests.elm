module ColorTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import Main exposing (..)
import Model exposing (..)
import Json.Decode exposing (decodeString, decodeValue)
import Json.Encode as Encode

colorJson : String
colorJson = """
            {"id":-1, "color":"black", "name":"none" }
        """
getColorValue : Int -> String -> String -> Encode.Value
getColorValue id color name= Encode.object [
        ("id", Encode.int id)
        ,("color", Encode.string color)
        ,("name", Encode.string name)
    ]

decoderColor : Test
decoderColor =
    test "test color decoder" 
    (\_-> 
        colorJson
        |> decodeString colorDecoder
        |> Expect.equal (Ok (Color -1 "black" "none" ) )
    )
            
decoderPropColor : Test
decoderPropColor =
     test "test color property name"
     (\_ ->
        colorJson
        |> decodeString colorDecoder
        |> Result.map .name
        |> Expect.equal (Ok "none")
     )

decodeColorValue : Test
decodeColorValue =
    test "test color encoded value"  
    (\_ ->
        getColorValue -1 "black" "none"
        |> decodeValue colorDecoder
        |> Result.map .name
        |> Expect.equal (Ok "none")
     )

decodeColorFuzz : Test
decodeColorFuzz = 
    fuzz3 int string string "test color with fuzzer"
    (\id color name ->
        getColorValue id color name
        |> decodeValue colorDecoder
        |> Result.map .name 
        |> Expect.equal (Ok name)
    )