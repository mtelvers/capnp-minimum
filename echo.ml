module Api = Echo_api.MakeRPC(Capnp_rpc)

open Capnp_rpc.Std

let read_from_file filename = In_channel.with_open_text filename @@ fun ic -> In_channel.input_all ic

let local =
  let module Echo = Api.Service.Echo in
  Echo.local @@ object
    inherit Echo.service

    method get_impl params release_param_caps =
      let open Echo.Get in
      let msg = Params.msg_get params in
      release_param_caps ();
      let response, results = Service.Response.create Results.init_pointer in
      Results.reply_set results (read_from_file msg);
      Service.return response
  end

module Echo = Api.Client.Echo

let get t msg =
  let open Echo.Get in
  let request, params = Capability.Request.create Params.init_pointer in
  Params.msg_set params msg;
  Capability.call_for_value_exn t method_id request |> Results.reply_get

