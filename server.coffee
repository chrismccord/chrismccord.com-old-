Settings =
  root: "./public"
  port: process.env.PORT || 3000

http          = require 'http'
fs            = require 'fs'
static        = require 'node-static'

staticServer = new static.Server(Settings.root)

server = http.createServer (request, response) ->
  url = require('url').parse(request.url)
  if url.pathname.search(/(javascripts\/)|(images\/)|(stylesheets\/)/g) < 0
    console.log "Serving up #{url.pathname}"
  request.addListener 'end', ->
    staticServer.serve(request, response)

server.listen(Settings.port)

console.log "server started on port #{Settings.port}"
