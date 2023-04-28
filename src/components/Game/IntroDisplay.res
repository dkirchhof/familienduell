module Styles = {
  open Emotion

  let intro = css(`
    display: flex;
    align-items: center;
    justify-content: center;

    padding: 1rem;
    box-sizing: border-box;

    font-size: 2rem;
    text-align: center;
  `)
}

type props = {name: string}

let make = props => {
  <div className=Styles.intro>
    {React.string(props.name)}
    <audio src="/assets/sounds/intro.ogg" autoPlay=true />
  </div>
}
