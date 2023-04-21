module Styles = {
  open Emotion

  let container = css(`
    display: flex;
    align-items: center;
    justify-content: center;
  `)
}

type props = {faceOff: FaceOff.t}

let make = props => {
  <div className=Styles.container>
    <img src={`/assets/images/${Int.toString((props.faceOff.multiplicator :> int))}.png`} />
    <audio src="/assets/sounds/roundIntro.ogg" autoPlay=true />
  </div>
}
