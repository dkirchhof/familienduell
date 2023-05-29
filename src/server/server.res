let app = Oak.Application.make()
let router = Oak.Router.make()
let clients = ref([])

Oak.Router.get(router, "/send", _ => {
  Array.forEach(clients.contents, target => {
    Oak.Target.dispatchMessage(target, {"hello": "world"})
  })
})

Oak.Router.get(router, "/sse", ctx => {
  let target = Oak.Context.sendEvents(ctx)

  clients := Array.concat(clients.contents, [target])

  Oak.Target.addEventListener(target, "close", () => {
    clients := Array.filter(clients.contents, t => t !== target)
  })

  Oak.Target.dispatchMessage(target, {"hello": "world"})
})

Oak.Application.use(app, Oak.cors())
Oak.Application.use(app, Oak.Router.routes(router))
Oak.Application.use(app, Oak.Router.allowedMethods(router))

Oak.Application.listen(app, {"port": 8000})
