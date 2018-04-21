open Lwt

let create_socket () =
  let open Lwt_unix in
  let sock = socket PF_INET SOCK_STREAM 0 in
  bind sock @@ ADDR_INET(Unix.inet_addr_loopback, 8080) >>= fun () ->
  listen sock 10;
  return sock

let rec handle_message ic oc () =
  Lwt_io.read_line_opt ic >>= fun msg ->
  match msg with
  | Some msg ->
    let ret = match msg with
    | "ping" -> "pong"
    | _ -> "unsupported command: " ^ msg
    in Lwt_io.write_line oc ret >>= handle_message ic oc
  | None -> return_unit

let handle_connection conn =
  let fd, _ = conn in
  let ic = Lwt_io.of_fd Lwt_io.Input fd in
  let oc = Lwt_io.of_fd Lwt_io.Output fd in
  print_endline "conn";
  Lwt.ignore_result (handle_message ic oc ());
  return_unit

let create_server sock =
  let rec serve () =
    Lwt_unix.accept sock >>= handle_connection >>= serve
  in serve

let () =
  Lwt_main.run ((create_socket ()) >>= fun sock ->
    let serve = create_server sock in serve ())
