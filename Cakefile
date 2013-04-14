{exec} = require 'child_process'

build = (callback) ->
  exec 'mkdir -p lib', (err, stdout, stderr) ->
    throw new Error(err) if err
    exec "coffee --compile --output lib/ src/", (err, stdout, stderr) ->
      throw new Error(err) if err
      callback() if callback

task 'build', 'Build lib from src', -> build()
