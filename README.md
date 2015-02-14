# node-cocoa-http
Using CocoaHTTPServer in node via NodObjC

Note: 

Needs a patched NodObjC 1.0.0. Add 

    else if (basetype[0] == '@') return createObject(val, '@');

as line 182 in

    ./node_modules/NodObjC/lib/core.js
  
Test:
  
    [term 1] coffee app.coffee
  
    [term 2] curl localhost:8080 -d '{"a":42}
