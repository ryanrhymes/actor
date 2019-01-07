
open Actor_mapre_types

module M = Actor_mapre.Make (Actor_net_zmq) (Actor_sys_unix)


let main args =
  Owl_log.(set_level DEBUG);
  let myself = args.(1) in
  let server = args.(2) in
  let client = Array.sub args 3 (Array.length args - 3) in
  let waiting = Hashtbl.create 128 in

  let book = Hashtbl.create 128 in
  Hashtbl.add book server "tcp://127.0.0.1:5555";

  if myself <> server then (
    let addr = "tcp://127.0.0.1:5556" in
    Hashtbl.add book myself addr
  )
  else (
    Array.iter (fun key ->
      Hashtbl.add waiting key "waiting"
    ) client
  );

  let contex = {
    myself;
    server;
    client;
    book;
    waiting;
  }
  in

  Lwt_main.run (M.init contex)


let _ =
  main Sys.argv
