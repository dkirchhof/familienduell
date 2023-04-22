module Styles = {
  open Emotion

  let container = css(`
    display: flex;
    align-items: center;
    justify-content: center;
  `)
}

@react.component
let make = () => {
  <div className=Styles.container>
    <img src={`/assets/images/intro.png`} />
    <audio src="/assets/sounds/roundIntro.ogg" autoPlay=true />
  </div>
}
