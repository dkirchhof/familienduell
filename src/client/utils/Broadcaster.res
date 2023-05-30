type options = BroadcastChannel(string) | ServerSendEvent(string)

type data =
  | UpdateDisplay(DisplayState.t)
  | UpdateDisplayAnimated(DisplayState.t)
  | PlaySound(AudioPlayer.file)
  | PlaySoundLimited(AudioPlayer.file, int)

type event = {data: data}
type jsonEvent = {data: string}

module Sender = {
  type t = BroadcastChannel(BroadcastChannel.sender) | ServerSendEvent(ServerSendEvent.sender)

  let make = (options: options): t => {
    switch options {
    | BroadcastChannel(channelName) => BroadcastChannel.makeSender(channelName)->BroadcastChannel
    | ServerSendEvent(serverUrl) => ServerSendEvent.makeSender(serverUrl)->ServerSendEvent
    }
  }

  let sendEvent = (sender: t, event: data) => {
    switch sender {
    | BroadcastChannel(channel) => BroadcastChannel.sendEvent(channel, event)
    | ServerSendEvent(serverUrl) => ServerSendEvent.sendEvent(serverUrl, event)
    }
  }
}

module Receiver = {
  type t = BroadcastChannel(BroadcastChannel.receiver) | ServerSendEvent(ServerSendEvent.receiver)

  let make = (options: options): t => {
    switch options {
    | BroadcastChannel(channelName) => BroadcastChannel.makeReceiver(channelName)->BroadcastChannel
    | ServerSendEvent(serverUrl) => ServerSendEvent.makeReceiver(serverUrl)->ServerSendEvent
    }
  }

  let listen = (receiver: t, callback) => {
    switch receiver {
    | BroadcastChannel(channel) =>
      BroadcastChannel.addEventListener(channel, (event: event) => event.data->callback)
    | ServerSendEvent(eventSource) =>
      ServerSendEvent.addEventListener(eventSource, (event: jsonEvent) =>
        event.data->JSON.parseExn->Obj.magic->callback
      )
    }
  }

  // let unlisten = (receiver: t) => {
  //   switch receiver {
  //   | BroadcastChannel(channel) => BroadcastChannel.close(channel)
  //   }
  // }
}
