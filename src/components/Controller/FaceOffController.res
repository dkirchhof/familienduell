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

type props = {faceOff: FaceOff.t, update: FaceOff.t => unit, nextRound: Team.choice => unit}

let make = props => {
  let selectAnswer = answer => {
    FaceOff.selectAnswer(props.faceOff, answer)->props.update
  }

  let revealAnswer = answer => {
    FaceOff.revealAnswer(props.faceOff, answer)->props.update
  }

  let lockTeam = team => {
    FaceOff.lockTeam(props.faceOff, team)->props.update

    let _ = setTimeout(() => {
      FaceOff.unlockTeam(props.faceOff, team)->props.update
    }, 1000)
  }

  let addStrike = team => {
    FaceOff.addStrike(props.faceOff, team)->props.update
  }

  <div>
    <div> {React.string(`Runde ${roundToString(props.faceOff.round)}`)} </div>
    <div> {React.string(`Frage: ${props.faceOff.question.text}`)} </div>
    <table className=Styles.table>
      <tbody>
        {props.faceOff.question.answers
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
          <td> {React.string(`Punkte: ${Int.toString(props.faceOff.team1.points)}`)} </td>
          <td> {React.string(`Gesperrt: ${boolToString(props.faceOff.team1.locked)}`)} </td>
          <td> {React.string(`Strikes: ${Int.toString(props.faceOff.team1.strikes)}`)} </td>
          <td>
            <button onClick={_ => lockTeam(Team1)}> {React.string("Sperren")} </button>
          </td>
          <td>
            <button onClick={_ => addStrike(Team1)}> {React.string("Strike hinzufügen")} </button>
          </td>
        </tr>
        <tr>
          <th> {React.string("Team 2")} </th>
          <td> {React.string(`Punkte: ${Int.toString(props.faceOff.team2.points)}`)} </td>
          <td> {React.string(`Gesperrt: ${boolToString(props.faceOff.team2.locked)}`)} </td>
          <td> {React.string(`Strikes: ${Int.toString(props.faceOff.team2.strikes)}`)} </td>
          <td>
            <button onClick={_ => lockTeam(Team2)}> {React.string("Sperren")} </button>
          </td>
          <td>
            <button onClick={_ => addStrike(Team2)}> {React.string("Strike hinzufügen")} </button>
          </td>
        </tr>
      </tbody>
    </table>
    <div> {React.string(`Summe aktuelle Runde: ${props.faceOff.points->Int.toString}`)} </div>
    <div>
      {React.string(
        `Summe aktuelle Runde: ${props.faceOff->FaceOff.getPointsWithMultiplicator->Int.toString}`,
      )}
    </div>
    <button onClick={_ => props.nextRound(Team1)}>
      {React.string("Runde beenden -> Team 1")}
    </button>
    <button onClick={_ => props.nextRound(Team2)}>
      {React.string("Runde beenden -> Team 2")}
    </button>
  </div>
}
