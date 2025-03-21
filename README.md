Run the server application passing it parameters of where to save the private key and which interface/port to listen on.

```sh
$ dune exec -- ./server.exe --capnp-secret-key-file ./server.pem --capnp-listen-address tcp:127.0.0.1:7000
+Server running. Connect using "echo.cap".
```

The `.cap` looks like this

```
capnp://sha-256:f5BAo2n_2gVxUdkyzYsIuitpA1YT_7xFg31FIdNKVls@127.0.0.1:7000/6v45oIvGQ6noMaLOh5GHAJnGJPWEO5A3Qkt0Egke4Ic
```

In another window, invoke the client.

```sh
$ dune exec -- ./client.exe ./echo.cap
```

