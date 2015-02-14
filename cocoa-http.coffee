"use strict"

$ = require "NodObjC"
$.import "Cocoa"
$.import "Foundation"
$.import "AppKit"
$.import "Security"
$.import "CoreData"
$.import "./HTTPServerFramework.framework"

{STATUS_CODES} = require "http"

{nsdict, dict, str, nsdata} = require "./cocoa-utils"

#
# Cocoa class to override HTTPResponse
#
httpResponse = $.HTTPDataResponse.extend("PostResponse")
httpResponse.addIvar "headers", "@"
httpResponse.addIvar "statusCode", "@"
httpResponse.addMethod "httpHeaders", "@@:", (self, sel) -> self.ivar("headers")
httpResponse.addMethod "status", "L@:", (self, sel) -> self.ivar("statusCode")("integerValue")
httpResponse.register()


#
# The incoming message (compatible with nodejs http, but not complete)
#
class HTTRequest
  constructor: (@method, @url, @headers, @body=null) ->
    @httpVersion = "1.1"


#
# The response object (compatible with nodejs http, but not complete)
#
class HTTPResponse
  constructor: (@connection, @request) ->
    @buffer = ""
    @statusCode = 200
    @reasonPhrase = "OK"
    @headers = {}
  
  setHeader: (name, value) ->
    headers[name] = value

  getHeader: (name) ->
    headers[name]

  writeHead: (statusCode, headers={}, reasonPhrase=null) ->
    @statusCode = statusCode
    @reasonPhrase = reasonPhrase ? STATUS_CODES[statusCode]
    @headers = headers

  write: (data, encoding="utf-8") ->
    @buffer += data

  end: (data, encoding) ->
    message = if data then nsdata(data) else nsdata(@buffer)
    response = $.PostResponse("alloc")("initWithData", message)
    response.ivar "statusCode", $(@statusCode)
    response.ivar "headers", nsdict(@headers)
    return response


#
# Cocoa based HTTP Server
#
class CocoaHTTPServer
  classCounter = 1

  @createServer: (handler) ->
    # console.log "createServer"
    new CocoaHTTPServer(handler)

    
  constructor: (@handler) ->
    # console.log "constructor"
    @httpSrv = $.HTTPServer("alloc")("init")
    @httpSrv("setType", $("_http._tcp."))

    connection = $.HTTPConnection.extend("PostConnection#{classCounter++  }")
    .addMethod "expectsRequestBodyFromMethod:atPath:", "c@:@@:", (self, sel, method, path) ->
      console.log "expectsRequestBodyFromMethod"
      return $.YES
    .addMethod "supportsMethod:atPath:", "c@:@@", (self, sel, method, path) ->
      console.log "supportsMethod"
      return $.YES
    .addMethod "processBodyData:", "v@:@", (self, sel, postDataChunk) ->
      console.log "processBodyData"
      self.ivar("request")("appendData", postDataChunk)
      return
    .addMethod "httpResponseForMethod:URI:", "@@:@@", (self, sel, method, uri) =>
      console.log "httpResponseForMethod"
      request = self.ivar("request")
      body = str(request "body")
      headers = dict(request "allHeaderFields")
      clientRequest = new HTTRequest method, uri, headers, body
      clientResponse = new HTTPResponse self, request
      return @handler clientRequest, clientResponse
    .register()
    console.log connection
    @httpSrv "setConnectionClass", connection("class")

    @error = $.alloc("NSError").ref()

  listen: (port=8080) ->
    @httpSrv("setPort", $(port))
    @httpSrv("start", @error)
    console.log "server listening to port #{port}"
    return @

exports.CocoaHTTPServer = CocoaHTTPServer

