type props = {className?: string, editorRef: React.ref<CodeFlask.t>}

let make = props => {
  React.useEffect0(() => {
    props.editorRef.current = CodeFlask.make("#editor", {language: "js"})

    None
  })

  <div id="editor" className=?{props.className} />
}
