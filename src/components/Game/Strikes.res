module Styles = {
  open Emotion

  let container = css(`
    padding: 0.5rem 1rem;

    display: flex;
    justify-content: space-between;

    > div {
      width: 4rem;

      display: flex;
      justify-content: space-around;
    }
 `)

  let x = (strikes, min) => css(`color: ${Theme.Colors.get(strikes >= min ? #accent : #tertiary)}`)
}

type props = {
  teamBlue: Team.t,
  teamRed: Team.t,
}

let make = props =>
  <div className=Styles.container>
    <div>
      <span className={Styles.x(props.teamBlue.strikes, 1)}> {React.string("X")} </span>
      <span className={Styles.x(props.teamBlue.strikes, 2)}> {React.string("X")} </span>
      <span className={Styles.x(props.teamBlue.strikes, 3)}> {React.string("X")} </span>
    </div>
    <div>
      <span className={Styles.x(props.teamRed.strikes, 1)}> {React.string("X")} </span>
      <span className={Styles.x(props.teamRed.strikes, 2)}> {React.string("X")} </span>
      <span className={Styles.x(props.teamRed.strikes, 3)}> {React.string("X")} </span>
    </div>
  </div>
