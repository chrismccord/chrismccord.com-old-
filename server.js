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
    var url;
    url = require('url').parse(request.url);
    if (url.pathname.search(/(javascripts\/)|(images\/)|(stylesheets\/)/g) < 0) {
      console.log("Serving up " + url.pathname);
    }
    return request.addListener('end', function() {
      return staticServer.serve(request, response);
    });
  });
  server.listen(Settings.port);
  console.log("server started on port " + Settings.port);
}).call(this);
