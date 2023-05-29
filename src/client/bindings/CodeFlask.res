type t
type options = {language: string}

@module("codeflask") @new external make: (string, options) => t = "default"

@send external getCode: t => string = "getCode"
@send external updateCode: (t, string) => unit = "updateCode"
