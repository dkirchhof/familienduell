let clients: ref<array<Bun.WebSocket.t>> = ref([])

let spa = async _ => {
  Bun.File.make(`./public/index.html`)->Bun.Response.makeWithFile
}

Bun.Server.serve({
  port: 8000,
  routes: Dict.fromArray([("/", spa)]),
  fetch: async (req, server) => {
    let url = Bun.URL.make(req.url)

    if url.pathname === "/ws" {
      server.upgrade(req)
    } else {
      Bun.File.make(`./public/${url.pathname}`)->Bun.Response.makeWithFile
    }
  },
  websocket: {
    \"open": socket => {
      Console.log("open")
      clients := Array.concat(clients.contents, [socket])
    },
    close: socket => {
      Console.log("close")
      clients := Array.filter(clients.contents, client => client !== socket)
    },
    message: (_socket, message) => {
      Array.forEach(clients.contents, socket => {
        socket.send(message)
      })
    },
  },
})

Bun.NetworkInterface.getInterfaces()
->Dict.valuesToArray
->Array.flat
->Array.filter(interface => interface.family === "IPv4" && interface.netmask === "255.255.255.0")
->Array.forEach(interface => Console.log(`http://${interface.address}:8000`))
