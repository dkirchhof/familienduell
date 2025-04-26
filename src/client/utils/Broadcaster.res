type data =
  | UpdateDisplay(DisplayState.t)
  | UpdateDisplayAnimated(DisplayState.t)
  | PlaySound(AudioPlayer.file)
  | PlaySoundLimited(AudioPlayer.file, int)

type event = {data: data}
type jsonEvent = {data: string}

type t

let make = () => {
  WebSocket.make("/ws")
}

let sendEvent = (ws: WebSocket.t, event: data) => {
  Console.log(event)
  WebSocket.sendEvent(ws, event)
}

let listen = (ws: WebSocket.t, callback: data => unit) => {
  WebSocket.addEventListener(ws, (event: jsonEvent) =>
    event.data->JSON.parseExn->Obj.magic->callback
  )
}

//   // let unlisten = (receiver: t) => {
//   //   switch receiver {
//   //   | BroadcastChannel(channel) => BroadcastChannel.close(channel)
//   //   }
//   // }
