module Styles = {
  open Emotion

  let table = css(`
    border-collapse: collapse;
    border: 1px solid;
    
    tr {
      &[disabled] {
        opacity: 0.5;

        pointer-events: none;
      }
    }

    th, td {
      padding: 0.5rem;

      border: 1px solid;
    }
  `)

  let teamActions = css(`
    border-collapse: collapse;
    border: 1px solid;

    td {
      padding: 0.5rem;

      border: 1px solid;
    }
  `)
}

let boolToString = value =>
  switch value {
  | true => "Ja"
  | false => "Nein"
  }

let roundToString = (value: FaceOff.round) =>
  switch value {
  | Round1 => "Runde 1"
  | Round2 => "Runde 2"
  | Round3 => "Runde 3"
  | Round4 => "Runde 4"
  }

type props = {faceOff: FaceOff.t, nextRound: Team.choice => unit}

let make = props => {
  let (game, updateGame) = SimpleState.use(props.faceOff)

  React.useEffect1(() => {
    let _ = updateGame(props.faceOff)

    None
  }, [props.faceOff])

  let selectAnswer = answer => {
    FaceOff.selectAnswer(game, answer)
    ->updateGame
    ->Broadcaster.Reveal
    ->Broadcaster.sendEvent
  }

  let revealAnswer = answer => {
    FaceOff.revealAnswer(game, answer)
    ->updateGame
    ->Broadcaster.Reveal
    ->Broadcaster.sendEvent
  }

  let lockTeam = team => {
    FaceOff.lockTeam(game, team)->updateGame->Broadcaster.Strike->Broadcaster.sendEvent

    let _ = setTimeout(() => {
      FaceOff.unlockTeam(game, team)->updateGame->Broadcaster.Sync->Broadcaster.sendEvent
    }, 1000)
  }

  let addStrike = team => {
    FaceOff.addStrike(game, team)->updateGame->Broadcaster.Strike->Broadcaster.sendEvent
  }

  let points = game.points
  let x = FaceOff.getMultiplicator(game)
  let pointsX = FaceOff.getPointsWithMultiplicator(game)

  <div>
    <div> {React.string(roundToString(game.round))} </div>
    <div> {React.string(`Frage: ${game.question.text}`)} </div>
    <div> {React.string(`Punkte: ${Int.toString(points)}`)} </div>
    <div> {React.string(`Punkte x${Int.toString(x)}: ${Int.toString(pointsX)}`)} </div>
    <table className=Styles.table>
      <tbody>
        {game.question.answers
        ->Array.mapWithIndex((answer, i) =>
          <tr key={Int.toString(i)} disabled={answer.revealed}>
            <th> {(i + 1)->Int.toString->React.string} </th>
            <td> {answer.text->React.string} </td>
            <td> {answer.count->Int.toString->React.string} </td>
            <td>
              <button onClick={_ => selectAnswer(answer)}> {React.string(`Beantworten`)} </button>
            </td>
            <td>
              <button onClick={_ => revealAnswer(answer)}> {React.string(`Aufdecken`)} </button>
            </td>
          </tr>
        )
        ->React.array}
      </tbody>
    </table>
    <table className=Styles.table>
      <tbody>
        <tr>
          <th> {React.string("Team 1")} </th>
          <td> {React.string(`Punkte: ${Int.toString(game.team1.points)}`)} </td>
          <td> {React.string(`Gesperrt: ${boolToString(game.team1.locked)}`)} </td>
          <td> {React.string(`Strikes: ${Int.toString(game.team1.strikes)}`)} </td>
          <td>
            <button onClick={_ => lockTeam(Team1)}> {React.string("Sperren")} </button>
          </td>
          <td>
            <button onClick={_ => addStrike(Team1)}> {React.string("Strike hinzufügen")} </button>
          </td>
        </tr>
        <tr>
          <th> {React.string("Team 2")} </th>
          <td> {React.string(`Punkte: ${Int.toString(game.team2.points)}`)} </td>
          <td> {React.string(`Gesperrt: ${boolToString(game.team2.locked)}`)} </td>
          <td> {React.string(`Strikes: ${Int.toString(game.team2.strikes)}`)} </td>
          <td>
            <button onClick={_ => lockTeam(Team2)}> {React.string("Sperren")} </button>
          </td>
          <td>
            <button onClick={_ => addStrike(Team2)}> {React.string("Strike hinzufügen")} </button>
          </td>
        </tr>
      </tbody>
    </table>
    <button onClick={_ => props.nextRound(Team1)}>
      {React.string("Runde beenden -> Team 1")}
    </button>
    <button onClick={_ => props.nextRound(Team2)}>
      {React.string("Runde beenden -> Team 2")}
    </button>
  </div>
}
