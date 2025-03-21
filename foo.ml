module Api = Foo_api.MakeRPC(Capnp_rpc)

open Capnp_rpc.Std

let read_from_file filename = In_channel.with_open_text filename @@ fun ic -> In_channel.input_all ic

let local =
  let module Foo = Api.Service.Foo in
  Foo.local @@ object
    inherit Foo.service

    method get_impl params release_param_caps =
      let open Foo.Get in
      let name = Params.name_get params in
      release_param_caps ();
      let response, results = Service.Response.create Results.init_pointer in
      Results.reply_set results (read_from_file name);
      Service.return response
  end

module Foo = Api.Client.Foo

let get t name =
  let open Foo.Get in
  let request, params = Capability.Request.create Params.init_pointer in
  Params.name_set params name;
  Capability.call_for_value_exn t method_id request |> Results.reply_get

