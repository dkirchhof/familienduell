module Styles = {
  open Emotion

  let container = css(`
    padding: 0.25rem 1rem;

    display: flex;
    justify-content: space-between;

    font-size: 1.5rem;

    > div {
      width: 4rem;

      display: flex;
      justify-content: space-around;
    }
 `)

  let x = (team: Team.t, minStrikes) =>
    css(
      `color: ${Theme.Colors.get(team.strikes >= minStrikes || team.locked ? #accent : #tertiary)}`,
    )
}

type props = {
  teamBlue: Team.t,
  teamRed: Team.t,
}

let make = props =>
  <div className=Styles.container>
    <div>
      <span className={Styles.x(props.teamBlue, 1)}> {React.string("X")} </span>
      <span className={Styles.x(props.teamBlue, 2)}> {React.string("X")} </span>
      <span className={Styles.x(props.teamBlue, 3)}> {React.string("X")} </span>
    </div>
    <div>
      <span className={Styles.x(props.teamRed, 1)}> {React.string("X")} </span>
      <span className={Styles.x(props.teamRed, 2)}> {React.string("X")} </span>
      <span className={Styles.x(props.teamRed, 3)}> {React.string("X")} </span>
    </div>
  </div>
