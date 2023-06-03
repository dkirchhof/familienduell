module Styles = {
  open Emotion

  let button = css(`
    @media(max-width: 480px) {
      width: 100%;
      height: 3rem;
    }
  `)
}

type props = {
  children: React.element,
  onClick: unit => unit,
}

let make = props =>
  <button className=Styles.button onClick={_ => props.onClick()}> {props.children} </button>
