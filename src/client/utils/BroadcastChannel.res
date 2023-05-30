type sender
type receiver

@send external sendEvent: (sender, 'a) => unit = "postMessage"
@send external addEventListener: (receiver, @as("message") _, 'a => unit) => unit = "addEventListener"
@send external close: receiver => unit = "close"

@new external makeSender: string => sender = "BroadcastChannel"
@new external makeReceiver: string => receiver = "BroadcastChannel"
