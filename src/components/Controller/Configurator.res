module Styles = {
  open Emotion

  let editor = css(`
    position: relative;
    height: 30rem;
    overflow: hidden;

    border: 1px solid gainsboro;
  `)
}

type props = {setConfig: Config.t => unit}

let make = (props: props) => {
  let editorRef = React.useRef(Obj.magic())

  React.useEffect0(() => {
    let rawConfig =
      Dom.Storage2.localStorage
      ->Dom.Storage2.getItem("config")
      ->Option.getWithDefault(Config.exampleConfig)

    editorRef.current->CodeFlask.updateCode(rawConfig)

    None
  })

  let onSetConfigClick = _ => {
    let rawConfig = editorRef.current->CodeFlask.getCode

    Dom.Storage2.localStorage->Dom.Storage2.setItem("config", rawConfig)

    rawConfig->Config.parse->props.setConfig
  }

  <>
    <CodeEditor editorRef className=Styles.editor />
    <button onClick=onSetConfigClick> {React.string("Konfiguration übernehmen")} </button>
  </>
}
