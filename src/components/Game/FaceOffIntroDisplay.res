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
    <img src={`/${Int.toString((props.faceOff.multiplicator :> int))}.png`} />
    <audio src="/roundIntro.ogg" autoPlay=true />
  </div>
}
