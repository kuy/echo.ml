open Lwt

let create_socket () =
  let open Lwt_unix in
  let sock = socket PF_INET SOCK_STREAM 0 in
  bind sock @@ ADDR_INET(Unix.inet_addr_loopback, 8080) >>= fun () ->
  listen sock 10;
  return sock

let handle_message ic oc =
  Lwt_io.read_line_opt ic >>= fun msg_ ->
  let ret = match msg_ with
  | Some msg -> (match msg with
    | "ping" -> "pong"
    | _ -> "unsupported command: " ^ msg)
  | None -> "close" in
  return ret

let create_server sock =
  Lwt_unix.accept sock >>= fun conn ->
  let fd, _ = conn in
  let ic = Lwt_io.of_fd Lwt_io.Input fd in
  let oc = Lwt_io.of_fd Lwt_io.Output fd in
  print_endline "conn";
  handle_message ic oc >>= fun ret ->
  print_endline ret;
  Lwt_io.write_line oc ret

let () =
  Lwt_main.run ((create_socket ()) >>= create_server)
