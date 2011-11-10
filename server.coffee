Settings =
  root: "./public"
  port: process.env.PORT || 3000

require('coffee-script')
sys           = require 'sys'
http          = require 'http'
https         = require 'https'
fs            = require 'fs'
static        = require 'node-static'

twitter =
  host: "api.twitter.com"
  port: 443
  path: "/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=chris_mccord&count=3"

tweets = []
https.get(twitter, (res) ->
  res.on 'data', (data) ->
    tweets.push(tweet.text) for tweet in JSON.parse(data)
    console.log sys.inspect tweets
).on "error", (e) -> console.log "Got error from twitter: " + e.message

staticServer = new static.Server(Settings.root)

server = http.createServer (request, response) ->
  request.addListener 'end', -> staticServer.serve(request, response)

server.listen(Settings.port)

console.log "Server started on port #{Settings.port}"
