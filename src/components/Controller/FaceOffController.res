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
  next: FaceOff.t => unit,
}

let make = props => {
  let (game, setGame) = React.useState(_ => props.game)

  React.useEffect1(() => {
    setGame(_ => props.game)

    None
  }, [props.game])

  let updateDisplay = game => {
    Broadcaster.UpdateDisplay(FaceOffGame(game))->Broadcaster.sendEvent
  }

  let updateDisplayAnimated = game => {
    Broadcaster.UpdateDisplayAnimated(FaceOffGame(game))->Broadcaster.sendEvent
  }

  let playSound = sound => {
    Broadcaster.PlaySound(sound)->Broadcaster.sendEvent
  }

  let selectAnswer = answer => {
    let updatedGame = FaceOff.selectAnswer(game, answer)

    setGame(_ => updatedGame)
    updateDisplayAnimated(updatedGame)
    playSound(#revealBoth)
  }

  let revealAnswer = answer => {
    let updatedGame = FaceOff.revealAnswer(game, answer)

    setGame(_ => updatedGame)
    updateDisplayAnimated(updatedGame)
    playSound(#revealBoth)
  }

  let lockTeam = team => {
    let updatedGame = FaceOff.lockTeam(game, team)

    setGame(_ => updatedGame)
    updateDisplay(updatedGame)
    playSound(#fail)

    let _ = setTimeout(() => {
      let updatedGame = FaceOff.unlockTeam(game, team)

      setGame(_ => updatedGame)
      updateDisplay(updatedGame)
    }, 1000)
  }

  let addStrike = team => {
    let updatedGame = FaceOff.addStrike(game, team)

    setGame(_ => updatedGame)
    updateDisplay(updatedGame)
    playSound(#fail)
  }

  let endRound = team => {
    let updatedGame = FaceOff.endRound(game, team)

    setGame(_ => updatedGame)
    updateDisplay(updatedGame)
    playSound(#endFaceOff)
  }

  let points = game.points
  let x = (game.multiplicator :> int)
  let pointsX = FaceOff.getPointsWithMultiplicator(game)

  <div>
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
      <thead>
        <tr>
          <th> {React.string("Team Blau")} </th>
          <th> {React.string("Team Rot")} </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td> {React.string(`Punkte: ${Int.toString(game.teamBlue.points)}`)} </td>
          <td> {React.string(`Punkte: ${Int.toString(game.teamRed.points)}`)} </td>
        </tr>
        <tr>
          <td> {React.string(`Gesperrt: ${boolToString(game.teamBlue.locked)}`)} </td>
          <td> {React.string(`Gesperrt: ${boolToString(game.teamRed.locked)}`)} </td>
        </tr>
        <tr>
          <td> {React.string(`Strikes: ${Int.toString(game.teamBlue.strikes)}`)} </td>
          <td> {React.string(`Strikes: ${Int.toString(game.teamRed.strikes)}`)} </td>
        </tr>
        <tr>
          <td>
            <button onClick={_ => lockTeam(TeamBlue)}> {React.string("Sperren")} </button>
          </td>
          <td>
            <button onClick={_ => lockTeam(TeamRed)}> {React.string("Sperren")} </button>
          </td>
        </tr>
        <tr>
          <td>
            <button onClick={_ => addStrike(TeamBlue)}>
              {React.string("Strike hinzufügen")}
            </button>
          </td>
          <td>
            <button onClick={_ => addStrike(TeamRed)}>
              {React.string("Strike hinzufügen")}
            </button>
          </td>
        </tr>
        <tr>
          <td>
            <button onClick={_ => endRound(TeamBlue)}>
              {React.string("Punkte übertragen")}
            </button>
          </td>
          <td>
            <button onClick={_ => endRound(TeamRed)}> {React.string("Punkte übertragen")} </button>
          </td>
        </tr>
      </tbody>
    </table>
    <button onClick={_ => props.next(game)}> {React.string("Nächste Runde")} </button>
  </div>
}
