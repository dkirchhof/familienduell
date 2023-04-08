%%raw(`new EventSource("/esbuild").addEventListener("change", () => location.reload())`)

Emotion.injectGlobal(
  `
  :root {
    /* @font-face { */
    /*   font-family: "Electronic Highway Sign"; */
    /*   src: url("/EHSMB.TTF") format("truetype"); */
    /* } */

    @font-face {
      font-family: "Ericsson";
      src: url("/ericsson.TTF") format("truetype");
    }

    ${Theme.Colors.set(#primary, "#2D2D25")};
    ${Theme.Colors.set(#secondary, "#8f8c00")};
    ${Theme.Colors.set(#tertiary, "#161616")};
    ${Theme.Colors.set(#accent, "#ff0000")};
  }
`,
)

ReactDOM.querySelector("#app")
->Option.getExn
->ReactDOM.Client.createRoot
->ReactDOM.Client.Root.render(<App />)
