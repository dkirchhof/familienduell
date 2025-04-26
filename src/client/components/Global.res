let broadcaster = ref(Broadcaster.make())

let sendEvent = Broadcaster.sendEvent(broadcaster.contents, _)

let listenToEvents = Broadcaster.listen(broadcaster.contents, _)
