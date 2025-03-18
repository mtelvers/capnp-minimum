open Eio.Std
open Capnp_rpc_net

let () =
  Logs.set_level (Some Logs.Warning);
  Logs.set_reporter (Logs_fmt.reporter ())

let cap_file = "echo.cap"

let serve config =
  Switch.run @@ fun sw ->
  let service_id = Capnp_rpc_unix.Vat_config.derived_id config "main" in
  let restore = Restorer.single service_id (Echo.local) in
  let vat = Capnp_rpc_unix.serve ~sw ~restore config in
  match Capnp_rpc_unix.Cap_file.save_service vat service_id cap_file with
  | Error `Msg m -> failwith m
  | Ok () ->
    traceln "Server running. Connect using %S." cap_file;
    Fiber.await_cancel ()

open Cmdliner

let ( $$ ) f x = Term.(const f $ x)

let serve_cmd env =
  let doc = "run the server" in
  let info = Cmd.info "serve" ~doc in
  Cmd.v info (serve $$ Capnp_rpc_unix.Vat_config.cmd env)

let () =
  exit @@ Eio_main.run @@ fun env ->
  Cmd.eval (serve_cmd env)
