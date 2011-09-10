(function() {
  var Settings, fs, http, server, static, staticServer;
  Settings = {
    root: "./public",
    port: process.env.PORT || 3000
  };
  http = require('http');
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
