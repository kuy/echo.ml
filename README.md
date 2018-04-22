# echo.ml

Multi-client echo server written in OCaml with LWT.

## Environments

- ocaml `4.06.1`
- jbuilder `1.0+beta19.1`

## Build

```
jbuilder build
```

## Run

### 1. Launch Server

```
./_build/default/echo.exe
```

### 2. Connect to server using telnet

```
telnet localhost 8080
ping
```

### 3. Server returns response

```
pong
```

## License

MIT

## Author

Yuki Kodama / [@kuy](https://twitter.com/kuy)
