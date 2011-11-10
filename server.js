(function() {
  var Settings, fs, http, https, server, static, staticServer, sys;
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
  staticServer = new static.Server(Settings.root);
  server = http.createServer(function(request, response) {
    return request.addListener('end', function() {
      return staticServer.serve(request, response);
    });
  });
  server.listen(Settings.port);
  console.log("Server started on port " + Settings.port);
}).call(this);
