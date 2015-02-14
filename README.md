# node-cocoa-http
Using CocoaHTTPServer in node via NodObjC

Note: 

1) Needs a patched NodObjC 1.0.0. Add 

    else if (basetype[0] == '@') return createObject(val, '@');

as line 183 in

    ./node_modules/NodObjC/lib/core.js


2) Will not work when NSApplication run is used, since it switches to Cocoa eventloop, and CocoaHTTPServer uses GCD version of AsyncSockets. Hence it was useless for RPC between node Cocoa app and pure Cocoa app


Test:
  
    [term 1] coffee app.coffee
  
    [term 2] curl localhost:8080 -d '{"a":42}'
