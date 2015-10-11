# node-cocoa-http
Using CocoaHTTPServer in node via NodObjC needs a patched NodObjC (latest test using commit version b67444ad422c87706b80f33243f5a878ac29ec67 11.10.2015) 

Add as line 183 in `./node_modules/NodObjC/lib/core.js`:

    else if (basetype[0] == '@') return createObject(val, '@');


Note: 
Will not work when NSApplication run is used, since it switches to Cocoa eventloop, and CocoaHTTPServer uses GCD version of AsyncSockets. Hence it was useless for RPC between node Cocoa app and pure Cocoa app


### Test _without_ patched core.js:
  
Terminal #1

    $ coffee app.coffee
    [Class: PostConnection1]
    server listening to port 8080
    listening ...
  
Terminal #2 

    $ curl localhost:8080 -d '{"a":42}'

Terminal #1

    ...
    listening ...
    expectsRequestBodyFromMethod
    supportsMethod
    processBodyData
    /Users/bernhard/Development/node-cocoa-http/node_modules/NodObjC/node_modules/ffi/lib/callback.js:20
        throw err
        ^

    TypeError: self.ivar(...) is not a function
      at /Users/bernhard/Development/node-cocoa-http/cocoa-http.coffee:91:7
      at /Users/bernhard/Development/node-cocoa-http/node_modules/NodObjC/lib/core.js:255:31
      at /Users/bernhard/Development/node-cocoa-http/node_modules/NodObjC/node_modules/ffi/lib/callback.js:66:25

### Test _with_ patched core.js:
  
Terminal #1

    $ coffee app.coffee
    [Class: PostConnection1]
    server listening to port 8080
    listening ...
  
Terminal #2 

    $ curl localhost:8080 -d '{"a":42}'

Terminal #1

    ...
    listening ...
    expectsRequestBodyFromMethod
    supportsMethod
    processBodyData
    httpResponseForMethod
    HTTRequest {
      method: POST,
      url: /,
      headers:
       { 'User-Agent': 'curl/7.43.0',
         Accept: '*/*',
         Host: 'localhost:8080',
         'Content-Length': '8',
         'Content-Type': 'application/x-www-form-urlencoded' },
      body: '{"a":42}',
      httpVersion: '1.1' }


