(*
 * Actor - Parallel & Distributed Engine of Owl System
 * Copyright (c) 2016-2019 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)

module Make
  (Net : Actor_net.Sig)
  (Sys : Actor_sys.Sig)
  = struct

  open Actor_param_types


  let register s_addr c_uuid c_addr =
    Owl_log.debug ">>> %s Reg_Req" s_addr;
    let s = encode_message c_uuid c_addr Reg_Req in
    Net.send s_addr s


  let heartbeat s_addr c_uuid c_addr =
    let rec loop () =
      let%lwt () = Sys.sleep 10. in
      Owl_log.debug ">>> %s Heartbeat" s_addr;
      let s = encode_message c_uuid c_addr Heartbeat in
      let%lwt () = Net.send s_addr s in
      loop ()
    in
    loop ()


  let process context data =
    let m = decode_message data in
    let my_uuid = context.my_uuid in
    let my_addr = context.my_addr in

    match m.operation with
    | Reg_Rep -> (
        Owl_log.debug "<<< %s Reg_Rep" m.uuid;
        Lwt.return ()
      )
    | Exit -> (
        Owl_log.debug "<<< %s Exit" m.uuid;
        Lwt.return ()
      )
    | PS_Schd task -> (
        Owl_log.debug "<<< %s PS_Schd" m.uuid;
        Owl_log.warn "%s" task;
        let update = context.push task in
        let s = encode_message my_uuid my_addr (PS_Push update) in
        Net.send context.server_addr s
      )
    | _ -> (
        Owl_log.error "unknown message type";
        Lwt.return ()
      )


  let init context =
    let%lwt () = Net.init () in

    (* register client to server *)
    let s_uuid = context.my_uuid in
    let s_addr = context.my_addr in
    let m_addr = context.server_addr in
    let%lwt () = register context.server_addr s_uuid s_addr in

    (* start client service *)
    let thread_0 = heartbeat m_addr s_uuid s_addr in
    let thread_1 = Net.listen s_addr (process context) in
    let%lwt () = thread_0 in
    let%lwt () = thread_1 in

    (* clean up when client exits *)
    let%lwt () = Net.exit () in
    Lwt.return ()


end


(* ends here *)
