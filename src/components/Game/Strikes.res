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
  team1: Team.t,
  team2: Team.t,
}

let make = props =>
  <div className=Styles.container>
    <div>
      <span className={Styles.x(props.team1.strikes, 1)}> {React.string("X")} </span>
      <span className={Styles.x(props.team1.strikes, 2)}> {React.string("X")} </span>
      <span className={Styles.x(props.team1.strikes, 3)}> {React.string("X")} </span>
    </div>
    <div>
      <span className={Styles.x(props.team2.strikes, 1)}> {React.string("X")} </span>
      <span className={Styles.x(props.team2.strikes, 2)}> {React.string("X")} </span>
      <span className={Styles.x(props.team2.strikes, 3)}> {React.string("X")} </span>
    </div>
  </div>
