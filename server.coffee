Settings =
  root: "./public"
  port: process.env.PORT || 3000

http          = require 'http'
fs            = require 'fs'
static        = require 'node-static'

staticServer = new static.Server(Settings.root)

server = http.createServer (request, response) ->
  request.addListener 'end', ->
    staticServer.serve(request, response)

server.listen(Settings.port)

console.log "Server started on port #{Settings.port}"
