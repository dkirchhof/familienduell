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
}

let boolToString = value =>
  switch value {
  | true => "Ja"
  | false => "Nein"
  }

type props = {
  game: FaceOff.t,
  updateGame: FaceOff.t => FaceOff.t,
  next: unit => unit,
}

let make = props => {
  let selectAnswer = answer => {
    FaceOff.selectAnswer(props.game, answer)
    ->props.updateGame
    ->FaceOff
    ->Broadcaster.RevealBoth
    ->Broadcaster.sendEvent
  }

  let revealAnswer = answer => {
    FaceOff.revealAnswer(props.game, answer)
    ->props.updateGame
    ->FaceOff
    ->Broadcaster.RevealBoth
    ->Broadcaster.sendEvent
  }

  let lockTeam = team => {
    FaceOff.lockTeam(props.game, team)->props.updateGame->Broadcaster.Strike->Broadcaster.sendEvent

    let _ = setTimeout(() => {
      FaceOff.unlockTeam(props.game, team)
      ->props.updateGame
      ->FaceOff
      ->Broadcaster.Sync
      ->Broadcaster.sendEvent
    }, 1000)
  }

  let addStrike = team => {
    FaceOff.addStrike(props.game, team)->props.updateGame->Broadcaster.Strike->Broadcaster.sendEvent
  }

  let endRound = team => {
    FaceOff.endRound(props.game, team)
    ->props.updateGame
    ->Broadcaster.EndRound
    ->Broadcaster.sendEvent
  }

  let points = props.game.points
  let x = (props.game.multiplicator :> int)
  let pointsX = FaceOff.getPointsWithMultiplicator(props.game)

  <div>
    // <div> {React.string(roundToString(props.game.round))} </div>
    <div> {React.string(`Frage: ${props.game.question.text}`)} </div>
    <div> {React.string(`Punkte: ${Int.toString(points)}`)} </div>
    <div> {React.string(`Punkte x${Int.toString(x)}: ${Int.toString(pointsX)}`)} </div>
    <table className=Styles.table>
      <tbody>
        {props.game.question.answers
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
      <thead>
        <tr>
          <th> {React.string("Team 1")} </th>
          <th> {React.string("Team 2")} </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td> {React.string(`Punkte: ${Int.toString(props.game.team1.points)}`)} </td>
          <td> {React.string(`Punkte: ${Int.toString(props.game.team2.points)}`)} </td>
        </tr>
        <tr>
          <td> {React.string(`Gesperrt: ${boolToString(props.game.team1.locked)}`)} </td>
          <td> {React.string(`Gesperrt: ${boolToString(props.game.team2.locked)}`)} </td>
        </tr>
        <tr>
          <td> {React.string(`Strikes: ${Int.toString(props.game.team1.strikes)}`)} </td>
          <td> {React.string(`Strikes: ${Int.toString(props.game.team2.strikes)}`)} </td>
        </tr>
        <tr>
          <td>
            <button onClick={_ => lockTeam(Team1)}> {React.string("Sperren")} </button>
          </td>
          <td>
            <button onClick={_ => lockTeam(Team2)}> {React.string("Sperren")} </button>
          </td>
        </tr>
        <tr>
          <td>
            <button onClick={_ => addStrike(Team1)}> {React.string("Strike hinzufügen")} </button>
          </td>
          <td>
            <button onClick={_ => addStrike(Team2)}> {React.string("Strike hinzufügen")} </button>
          </td>
        </tr>
        <tr>
          <td>
            <button onClick={_ => endRound(Team1)}> {React.string("Punkte übertragen")} </button>
          </td>
          <td>
            <button onClick={_ => endRound(Team2)}> {React.string("Punkte übertragen")} </button>
          </td>
        </tr>
      </tbody>
    </table>
    <button onClick={_ => props.next()}> {React.string("Nächste Runde")} </button>
  </div>
}
