
# Module dependencies
express = require "express"
routes = require "./routes"
http = require "http"
path = require "path"

# Express web app
app = express()

app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# Error-handling middleware - development only 
if "development" == app.get "env"
  app.use express.errorHandler()

# routes
app.get '/', routes.index

# HTTP Server
http.createServer(app).listen app.get("port"), ->
  console.log "\nExpress server listening on port " + app.get("port");