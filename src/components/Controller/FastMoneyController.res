module Styles = {
  open Emotion

  let table = css(`
    border-collapse: collapse;
    border: 1px solid;
    
    th, td {
      padding: 0.5rem;

      border: 1px solid;

      &[disabled] {
        opacity: 0.5;

        pointer-events: none;
      }
    }
  `)

  let answer = css(`
    display: grid;
    grid-template-columns: 1fr auto auto;
    gap: 0.5rem;
  `)

  let input = css(`
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  `)
}

module Answers = {
  type props = {answers: array<TestData.answer>}

  let make = props => {
    <td>
      {props.answers
      ->Array.mapWithIndex((answer, i) =>
        <div key={Int.toString(i)} className=Styles.answer>
          <span> {React.string(`${answer.text} (${Int.toString(answer.count)})`)} </span>
          <button> {React.string("-> Spieler 1")} </button>
          <button> {React.string("-> Spieler 2")} </button>
        </div>
      )
      ->React.array}
    </td>
  }
}

module PlayerInputs = {
  type props = {
    answer: FastMoney.Answer.t,
    update: FastMoney.Answer.t => unit,
  }

  let make = props => {
    let onTextChange = event => {
      props.update({...props.answer, text: JsxEvent.Form.currentTarget(event)["value"]})
    }

    let onCountChange = event => {
      props.update({...props.answer, count: JsxEvent.Form.currentTarget(event)["valueAsNumber"]})
    }

    let revealText = () => {
      props.update({...props.answer, textRevealed: true})
    }

    let revealCount = () => {
      props.update({...props.answer, countRevealed: true})
    }

    <>
      <td disabled=props.answer.textRevealed>
        <div className=Styles.input>
          <input value={props.answer.text} onChange={onTextChange} />
          <button onClick={_ => revealText()}> {React.string("Aufdecken")} </button>
        </div>
      </td>
      <td disabled=props.answer.countRevealed>
        <div className=Styles.input>
          <input
            type_="number"
            min="0"
            max="100"
            value={props.answer.count->Int.toString}
            onChange={onCountChange}
          />
          <button onClick={_ => revealCount()}> {React.string("Aufdecken")} </button>
        </div>
      </td>
    </>
  }
}

type props = {
  game: FastMoney.t,
  updateGame: FastMoney.t => FastMoney.t,
}

let make = props => {
  let updateAnswer = (question, player, answer) => {
    FastMoney.updateAnswer(props.game, question, player, answer)->props.updateGame->ignore
  }

  /* let revealAnswer = answer => { */
  /* FaceOff.revealAnswer(props.game, answer) */
  /* ->props.updateGame */
  /* ->Broadcaster.Reveal */
  /* ->Broadcaster.sendEvent */
  /* } */

  /* let lockTeam = team => { */
  /* FaceOff.lockTeam(props.game, team)->props.updateGame->Broadcaster.Strike->Broadcaster.sendEvent */

  /* let _ = setTimeout(() => { */
  /* FaceOff.unlockTeam(props.game, team) */
  /* ->props.updateGame */
  /* ->Broadcaster.Sync */
  /* ->Broadcaster.sendEvent */
  /* }, 1000) */
  /* } */

  let points = FastMoney.getPoints(props.game)

  <div>
    <table className=Styles.table>
      <thead>
        <tr>
          <th />
          <th> {React.string("Frage")} </th>
          <th> {React.string("Antworten")} </th>
          <th> {React.string("Antwort Spieler 1")} </th>
          <th> {React.string("Punkte Spieler 1")} </th>
          <th> {React.string("Antwort Spieler 2")} </th>
          <th> {React.string("Punkte Spieler 2")} </th>
        </tr>
      </thead>
      <tbody>
        {props.game.questions
        ->Array.mapWithIndex((question, i) =>
          <tr key={Int.toString(i)}>
            <th> {(i + 1)->Int.toString->React.string} </th>
            <th> {question.text->React.string} </th>
            <Answers answers=question.answers />
            <PlayerInputs
              answer=question.answerPlayer1 update={updateAnswer(question, FastMoney.Player1)}
            />
            <PlayerInputs
              answer=question.answerPlayer2 update={updateAnswer(question, FastMoney.Player2)}
            />
          </tr>
        )
        ->React.array}
      </tbody>
    </table>
    <div>{React.string(`Summe: ${Int.toString(points)}`)}</div>
  </div>
}
