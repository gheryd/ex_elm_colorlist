const express = require("express");
const server = express();
const path = require('path');

const colors = [
    {id: 1, name:"green", color:"green"}
    ,{id: 2, name:"brown", color:"brown"}
    ,{id: 3, name:"red", color:"red"}
    ,{id: 4, name:"cyan", color:"cyan"}
    ,{id: 5, name:"chartreuse", color:"chartreuse"}
    ,{id: 6, name:"violet", color:"violet"}
    ,{id: 7, name:"aquamarine", color:"aquamarine"}
]

server.use((req, res, next) => {
    console.log("------> req "+req.method+"  " + req.url);
    next();
});

const fileAssets = express.static(
    path.join(__dirname, "../../dist")
)

server.use(fileAssets)

server.use("/api/colors", (req, res, next)=> {
    console.log("return colors")
    setTimeout(
        () => res.send( JSON.stringify(colors) )
        , 3000
    )
})


server.listen(3000, ()=>console.log("listen on port 3000..."));

