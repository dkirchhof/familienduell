module File = {
  type t

  @module("bun") external make: string => t = "file"
}

module Request = {
  type t = {url: string}
}

module Response = {
  type t = {write: string => unit}
  type options = {headers: Dict.t<string>}

  @new external make: string => t = "Response"
  @new external makeWithOptions: (string, options) => t = "Response"
  @new external makeWithFile: File.t => t = "Response"
}

module WebSocket = {
  type t = {send: string => unit}
}

module Server = {
  type t = {upgrade: Request.t => Response.t}

  type websocket = {
    \"open": WebSocket.t => unit,
    close: WebSocket.t => unit,
    message: (WebSocket.t, string) => unit,
  }

  type serveOptions = {
    port: int,
    routes: Dict.t<Request.t => promise<Response.t>>,
    fetch: (Request.t, t) => promise<Response.t>,
    websocket: websocket,
  }

  @module("bun") external serve: serveOptions => unit = "serve"
}

module NetworkInterface = {
  type t = {family: string, netmask: string, address: string}

  @module("os") external getInterfaces: unit => Dict.t<array<t>> = "networkInterfaces"
}

module URL = {
  type t = {pathname: string}

  @new external make: string => t = "URL"
}
