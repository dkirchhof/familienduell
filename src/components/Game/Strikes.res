module Styles = {
  open Emotion

  let container = css(`
    padding: 0.5rem 1.5rem;

    display: flex;
    justify-content: space-between;

    > div {
      width: 4rem;

      display: flex;
      justify-content: space-around;
    }
 `)

  let x = css(`
    color: ${Theme.Colors.get(#tertiary)};
 `)
}

@react.component
let make = () =>
  <div className=Styles.container>
    <div>
      <span className=Styles.x> {React.string("X")} </span>
      <span className=Styles.x> {React.string("X")} </span>
      <span className=Styles.x> {React.string("X")} </span>
    </div>
    <div>
      <span className=Styles.x> {React.string("X")} </span>
      <span className=Styles.x> {React.string("X")} </span>
      <span className=Styles.x> {React.string("X")} </span>
    </div>
  </div>
