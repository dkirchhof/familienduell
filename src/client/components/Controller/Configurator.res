module Styles = {
  open Emotion

  let editor = css(`
    position: relative;
    height: 30rem;
    overflow: hidden;

    border: 1px solid gainsboro;
  `)

  let error = css(`
    color: red;
  `)
}

type props = {setConfig: Config.t => unit}

let make = (props: props) => {
  let editorRef = React.useRef(Obj.magic())

  let (error, setError) = React.useState(_ => "")

  React.useEffect0(() => {
    let rawConfig =
      Dom.Storage2.localStorage
      ->Dom.Storage2.getItem("config")
      ->Option.getWithDefault(Config.exampleConfig)

    editorRef.current->CodeFlask.updateCode(rawConfig)

    None
  })

  let onSetConfigClick = _ => {
    let configJson = editorRef.current->CodeFlask.getCode

    Dom.Storage2.localStorage->Dom.Storage2.setItem("config", configJson)

    switch Config.loadFromJson(configJson) {
    | Ok(config) => props.setConfig(config)
    | Error(error) => setError(_ => JSON.stringifyAnyWithIndent(error, 2)->Option.getExn)
    }
  }

  <>
    <CodeEditor editorRef className=Styles.editor />
    <p className=Styles.error> {React.string(error)} </p>
    <Button onClick=onSetConfigClick> {React.string("Konfiguration übernehmen")} </Button>
  </>
}
