%%raw(`
  if (process.env.NODE_ENV === "development") {
    new EventSource("/esbuild").addEventListener("change", () => location.reload())
  }
`)

Emotion.injectGlobal(
  `
  @font-face {
    font-family: "Ericsson";
    src: url("/assets/fonts/ericsson.TTF") format("truetype");
  }

  @keyframes reveal-right {
    from {
      clip-path: inset(0% 100% 0% 0%);
    }
    to {
      clip-path: inset(0% 0% 0% 0%);
    }
  }

  ::view-transition-old(root) {
    animation: none;
  }

  ::view-transition-new(root) {
    mix-blend-mode: normal;

    animation: reveal-right 1.5s steps(30);
  }

  ::view-transition-old(answer-player-1-text), 
  ::view-transition-old(answer-player-2-text) {
    animation: none;
  }

  ::view-transition-new(answer-player-1-text),
  ::view-transition-new(answer-player-2-text) {
    mix-blend-mode: normal;

    animation: reveal-right 0.75s steps(30);
  }

  :root {
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
