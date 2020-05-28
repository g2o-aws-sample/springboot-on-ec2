var express = require('express') //include express module
var app = express()  //creating object of express module

//callback function for a route(called when someone browses to the root of this web application. function will return service name from env variable)
app.get('/', function(req,res){
    res.send('Service name is ' + process.env.SERVICE_NAME);
})

//this server app will listen to client request on port 8080
app.listen(8080, ()=> console.log('listening on 8080'))