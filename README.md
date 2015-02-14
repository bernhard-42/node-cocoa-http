# node-cocoa-http
Using CocoaHTTPServer in node via NodObjC

Note: 

Needs a patched NodObjC 1.0.0. Add 

    if(basetype == '@' || basetype == '#') return createObject(val, basetype);

as line 182 in

    ./node_modules/NodObjC/lib/core.js
  
Test:
  
    [term 1] coffee app.coffee
  
    [term 2] curl localhost:8080 -d '{"a":42}
