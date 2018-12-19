module Model exposing (..)

type alias Color = {id: Int, color:String, name:String}

type Status
    = Loading
    | Loaded (List Color)
    | Errored String

type alias Model = {
        status: Status, 
        selected: Color
    }

voidColor: Color
voidColor = {
        id=  -1,
        color= "black",
        name= "none"
    }

initModel : Model
initModel = {
        status = Loading
        ,selected = voidColor
    }