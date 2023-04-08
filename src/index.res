%%raw(`new EventSource("/esbuild").addEventListener("change", () => location.reload())`)

/* Emotion.injectGlobal( */
/*   ` */
/*   :root { */
/*     /1* @font-face { *1/ */
/*     /1*   font-family: "Electronic Highway Sign"; *1/ */
/*     /1*   src: url("/EHSMB.TTF") format("truetype"); *1/ */
/*     /1* } *1/ */

/*     @font-face { */
/*       font-family: "Ericsson"; */
/*       src: url("/ericsson.TTF") format("truetype"); */
/*     } */

/*     ${Theme.Colors.set(#primary, "#2D2D25")}; */
/*     ${Theme.Colors.set(#secondary, "#8f8c00")}; */
/*     ${Theme.Colors.set(#tertiary, "#161616")}; */
/*     ${Theme.Colors.set(#accent, "#ff0000")}; */

/*     color: ${Theme.Colors.get(#secondary)}; */
/*     background: ${Theme.Colors.get(#primary)}; */

/*     font-family: Ericsson, monospace; */
/*     font-size: 3rem; */
/*     line-height: 1.2; */
/*     text-transform: uppercase; */
/*   } */

/*   body { */
/*     height: 100vh; */
/*     margin: 0; */
/*     padding: 0; */

/*     display: flex; */
/*     align-items: center; */
/*     justify-content: center; */
/*   } */
/* `, */
/* ) */

ReactDOM.querySelector("#app")
->Option.getExn
->ReactDOM.Client.createRoot
->ReactDOM.Client.Root.render(<App />)
