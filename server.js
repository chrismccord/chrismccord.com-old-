(function() {
  var Settings, fs, http, https, server, static, staticServer, sys, tweets, twitter;
  Settings = {
    root: "./public",
    port: process.env.PORT || 3000
  };
  require('coffee-script');
  sys = require('sys');
  http = require('http');
  https = require('https');
  fs = require('fs');
  static = require('node-static');
  twitter = {
    host: "api.twitter.com",
    port: 443,
    path: "/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=chris_mccord&count=3"
  };
  tweets = [];
  https.get(twitter, function(res) {
    return res.on('data', function(data) {
      var tweet, _i, _len, _ref;
      _ref = JSON.parse(data);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tweet = _ref[_i];
        tweets.push(tweet.text);
      }
      return console.log(sys.inspect(tweets));
    });
  }).on("error", function(e) {
    return console.log("Got error from twitter: " + e.message);
  });
  staticServer = new static.Server(Settings.root);
  server = http.createServer(function(request, response) {
    return request.addListener('end', function() {
      return staticServer.serve(request, response);
    });
  });
  server.listen(Settings.port);
  console.log("Server started on port " + Settings.port);
}).call(this);
