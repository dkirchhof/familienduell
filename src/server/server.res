let app = Oak.Application.make()
let router = Oak.Router.make()
let clients = ref([])

Oak.Router.post(router, "/bc", ctx => {
  let _ = Oak.Request.getBody(ctx.request)->Promise.thenResolve(body => {
    Array.forEach(
      clients.contents,
      target => {
        Oak.Target.dispatchMessage(target, body)
      },
    )

    Oak.Context.setBody(ctx, "OK")
  })
})

Oak.Router.get(router, "/sse", ctx => {
  let target = Oak.Context.sendEvents(ctx)

  clients := Array.concat(clients.contents, [target])

  Oak.Target.addEventListener(target, "close", () => {
    clients := Array.filter(clients.contents, t => t !== target)
  })
})

Oak.Application.use(app, Oak.cors())
Oak.Application.use(app, Oak.Router.routes(router))
Oak.Application.use(app, Oak.Router.allowedMethods(router))
Oak.Application.use(app, StaticFiles.serve("public/"))

Oak.Application.listen(app, {"port": 8000})

Deno.networkInterfaces()
->Array.filter(interface => interface.family === "IPv4" && interface.netmask === "255.255.255.0")
->Array.map(interface => interface.address)
->Array.forEach(ip => Console.log(`http://${ip}:8000`))
