type sender = {serverUrl: string}
type receiver

type options = {method: [#POST], body: string}

external fetch: (string, options) => unit = "fetch"

@new external makeEventSource: string => receiver = "EventSource"
@send external addEventListener: (receiver, @as("message") _, 'a => unit) => unit = "addEventListener"

let sendEvent = (sender, event) => {
  fetch(
    sender.serverUrl,
    {
      method: #POST,
      body: JSON.stringifyAny(event)->Option.getExn,
    },
  )
}

let makeSender = serverUrl => {serverUrl: `${serverUrl}/bc`}
let makeReceiver = serverUrl => makeEventSource(`${serverUrl}/sse`)
