module Application = {
  type t

  @module("https://deno.land/x/oak/mod.ts") @new external make: unit => t = "Application"

  @send external use: (t, 'a) => unit = "use"
  @send external listen: (t, {"port": int}) => unit = "listen"
}

module Target = {
  type t

  @send external dispatchMessage: (t, {..}) => unit = "dispatchMessage"
  @send external addEventListener: (t, string, unit => unit) => unit = "addEventListener"
}

module Request = {
  type t

  let getBody: t => 'a = %raw(`
    function(request) {
      return request.body().value;
    }
  `)
}

module Context = {
  type t = {request: Request.t}

  @send external sendEvents: t => Target.t = "sendEvents"

  let setBody: (t, string) => unit = %raw(`
    function(ctx, body) {
      ctx.response.body = body; 
    }
  `)
}

module Router = {
  type t

  @module("https://deno.land/x/oak/mod.ts") @new external make: unit => t = "Router"

  @send external routes: t => {..} = "routes"
  @send external allowedMethods: t => {..} = "allowedMethods"

  @send external get: (t, string, Context.t => unit) => unit = "get"
  @send external post: (t, string, Context.t => unit) => unit = "post"
}

@module("https://deno.land/x/cors/mod.ts") @val external cors: unit => {..} = "oakCors"
