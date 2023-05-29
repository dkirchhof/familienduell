module Styles = {
  open Emotion

  let container = css(`
    display: flex;
    align-items: center;
    justify-content: center;
  `)
}

type props = {multiplicator: FaceOff.multiplicator}

let make = props => {
  <div className=Styles.container>
    <img src={`/assets/images/${Int.toString((props.multiplicator :> int))}.png`} />
    <audio src="/assets/sounds/faceOffIntro.ogg" autoPlay=true />
  </div>
}
