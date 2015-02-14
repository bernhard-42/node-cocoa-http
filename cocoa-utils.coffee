"use strict"

$ = require "NodObjC"
$.import "Cocoa"

#
# nsdict: Create an NSMutableDictionary from a one level JSON dict
#
nsdict = (dict) ->
  l = Object.keys(dict).length
  keys = $.NSMutableArray "arrayWithCapacity", l
  vals = $.NSMutableArray "arrayWithCapacity", l
  for k,v of dict
    keys "addObject", $(k)
    vals "addObject", if typeof v in ["object", "function"] then v else $(v)
  $.NSMutableDictionary "dictionaryWithObjects", vals, "forKeys", keys

#
# nsdict: Create a one level JSON dict from an NSMutableDictionary
#
dict = (nsdict) ->
  result = {}
  keys = nsdict("allKeys")
  for i in [0..keys("count")-1]
    key = keys("objectAtIndex", i)
    result[key.toString()] = nsdict("objectForKey", key).toString()
  result

#
# str: Convert NSData to javascript string
#
str = (nsdata) ->
  $.NSString("alloc")("initWithData", nsdata, "encoding", $.NSUTF8StringEncoding).toString()

#
# nsdata: Convert javascript string to NSData
#
nsdata = (str, encoding="utf-8") ->
  if encoding=="utf-8"
    $(str)("dataUsingEncoding", $.NSUTF8StringEncoding)
  else
    throw new Error "Only utf-8 encoding supprted"



exports.nsdict = nsdict
exports.dict = dict
exports.str = str
exports.nsdata = nsdata
