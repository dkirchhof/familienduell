type t = {send: string => unit}

@new external make: string => t = "WebSocket"

let sendEvent = (ws, event) => {
  JSON.stringifyAny(event)->Option.getExn->ws.send
}

@send external addEventListener: (t, @as("message") _, 'a => unit) => unit = "addEventListener"
