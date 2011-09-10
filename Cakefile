fs            = require 'fs'
{print}       = require 'sys'
{spawn, exec} = require 'child_process'

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false
  public_options = ['-c', '-o', 'public/javascripts', 'src']
  public_options.unshift '-w' if watch

  coffee_pub = spawn 'coffee', public_options
  coffee_pub.stdout.on 'data', (data) -> print data.toString()
  coffee_pub.stderr.on 'data', (data) -> print data.toString()
  coffee_pub.on 'exit', (status) -> callback?() if status is 0
 
  lib_options = ['-c', '-o', 'lib', 'src']
  lib_options.unshift '-w' if watch 
  coffee_lib = spawn 'coffee', lib_optoins
  coffee_lib.stdout.on 'data', (data) -> print data.toString()
  coffee_lib.stderr.on 'data', (data) -> print data.toString()
  coffee_lib.on 'exit', (status) -> callback?() if status is 0

task 'docs', 'Generate annotated source code with Docco', ->
  fs.readdir 'src', (err, contents) ->
    files = ("src/#{file}" for file in contents when /\.coffee$/.test file)
    docco = spawn 'docco', files
    docco.stdout.on 'data', (data) -> print data.toString()
    docco.stderr.on 'data', (data) -> print data.toString()
    docco.on 'exit', (status) -> callback?() if status is 0

task 'build', 'Compile CoffeeScript source files', ->
  build()

task 'watch', 'Recompile CoffeeScript source files when modified', ->
  build true

task 'start', 'Start/monitor server and watch source files', ->
  nodemon = spawn 'nodemon', ['server.js']
  nodemon.stdout.on 'data', (data) -> print data.toString()
  nodemon.stderr.on 'data', (data) -> print data.toString()
  nodemon.on 'exit', (status) -> callback?() if status is 0
  build true

task 'test', 'Run the test suite', ->
  build ->
    require.paths.unshift __dirname + "/public/javascripts"
    {reporters} = require 'nodeunit'
    process.chdir __dirname
    reporters.default.run ['test']
