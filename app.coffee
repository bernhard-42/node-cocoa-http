{CocoaHTTPServer} = require "./cocoa-http"
q = require "q"

handler = (request, response) ->
  console.log request

httpServer = new CocoaHTTPServer(handler)
httpServer.listen()

console.log "listening ..."
setTimeout ->
  console.log "end"
, 10000000