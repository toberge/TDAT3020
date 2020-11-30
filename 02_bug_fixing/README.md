# Issue: Server crashes on HTTP requests with non-float version numbers

## The bug

Sending a GET request (through telnet or other means) with a non-parsable version number crashes the server, though only after it has sent a response.

```
$ telnet localhost 8080
Trying ::1...
Connected to localhost.
Escape character is '^]'.
GET / HTTP/thisisnotanumber

HTTP/1.1 200 OK
Content-Length: 35

<h1>The web server is working!</h1>Connection closed by foreign host.
```

Invalid requests like `GET / HTTP/1.1e-4` or `GET / HTTP/-3` do not crash the server, as those are valid floating point numbers in C++.

Requests like

+ `GET / HTTP/4lph4num3r1c`
+ `GET / HTTP/99999999999999999999999999999999999999999999999999`

are not parseable as floats (the latter because it exceeds the maximum precision of a float) and thus crash the server.

## Reproducing

Perform any GET request with a large or letter-based version number, as stated above.

## Additional details

+ OS: Manjaro Linux, kernel version `5.7.14-1`
+ g++ version: 10.1.0
+ cmake version: 3.18.1
+ make version: 4.3
+ boost version: 1.71.0-2
+ gdb version: 9.2

## Stack trace

See **stacktrace.txt** (not included here)

Gotten with the method specified in the README.

# Patch

```diff
      return;
    }
  }
- if(std::stof(response->session->request->http_version) >= 1.1) {
+
+ float version;
+ try { // stof() calls will throw if the string cannot be parsed
+   version = std::stof(response->session->request->http_version);
+ } catch (const std::invalid_argument& e) { // not parseable as float
+   version = 1.0; // assume version 1.0
+ } catch (const std::out_of_range& e) { // exceeds float range
+   version = 1.0; // assume version 1.0
+ }
+ if(version >= 1.1) {
+   // In HTTP/1.1 and above, persistent connections were introduced
    auto new_session = std::make_shared<Session>(this->config.max_request_streambuf_size, response->session->connection);
    this->read(new_session);
    return;
```


# Merge request: Fix issue \#9 (crash on float parsing)

+ Wrapped std::stof() call in a try-catch statement
+ Assuming version 1.0 when the version number is invalid  
  (thus skipping the behaviour specific to HTTP/1.1 and above)

Feel free to comment if this error should be handled differently.  
See the desription of issue #9 for more information.
