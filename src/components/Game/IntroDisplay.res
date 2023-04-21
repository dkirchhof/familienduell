module Styles = {
  open Emotion

  let intro = css(`
    display: flex;
    align-items: center;
    justify-content: center;
  `)
}

@react.component
let make = () => {
  <div className=Styles.intro>
    <img src="/assets/images/intro.png" />
    <audio src="/assets/sounds/intro.ogg" autoPlay=true />
  </div>
}
