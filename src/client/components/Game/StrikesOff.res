module Styles = {
  open Emotion

  let container = css(
    `
    padding: 0.25rem 1rem;

    display: flex;
    justify-content: space-between;

    font-size: 1.5rem;

    > div {
      width: 4rem;

      display: flex;
      justify-content: space-around;

      > span {
        color: ${Theme.Colors.get(#tertiary)}
      }
    }
 `,
  )
}

@react.component
let make = () =>
  <div className=Styles.container>
    <div>
      <span> {React.string("X")} </span>
      <span> {React.string("X")} </span>
      <span> {React.string("X")} </span>
    </div>
    <div>
      <span> {React.string("X")} </span>
      <span> {React.string("X")} </span>
      <span> {React.string("X")} </span>
    </div>
  </div>
