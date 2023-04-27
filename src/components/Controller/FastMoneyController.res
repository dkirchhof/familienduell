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

  let timer = css(`
    display: flex;
    gap: 0.5rem;
    align-items: center;
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
  type props = {
    answers: array<(string, int)>,
    select: (FastMoney.player, (string, int)) => unit,
  }

  let make = props => {
    <td>
      {props.answers
      ->Array.mapWithIndex((answer, i) =>
        <div key={Int.toString(i)} className=Styles.answer>
          <span> {React.string(`${fst(answer)} (${Int.toString(snd(answer))})`)} </span>
          <button onClick={_ => props.select(Player1, answer)}>
            {React.string("-> Spieler 1")}
          </button>
          <button onClick={_ => props.select(Player2, answer)}>
            {React.string("-> Spieler 2")}
          </button>
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
    revealText: FastMoney.Answer.t => unit,
    revealCount: FastMoney.Answer.t => unit,
  }

  let make = props => {
    let onTextChange = event => {
      props.update({...props.answer, text: JsxEvent.Form.currentTarget(event)["value"]})
    }

    let onCountChange = event => {
      props.update({...props.answer, count: JsxEvent.Form.currentTarget(event)["valueAsNumber"]})
    }

    let revealText = () => {
      props.revealText({...props.answer, textRevealed: true})
    }

    let revealCount = () => {
      props.revealCount({...props.answer, countRevealed: true})
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
  updateTimer: (FastMoney.player, FastMoney.Timer.t) => unit,
}

let make = props => {
  let startTimer = player => {
    let interval = ref(Obj.magic())
    let time = FastMoney.getTimer(props.game, player)->FastMoney.Timer.getTime->ref

    props.updateTimer(player, FastMoney.Timer.Visible(time.contents))

    interval := setInterval(() => {
        time := time.contents - 1

        props.updateTimer(player, FastMoney.Timer.Visible(time.contents))

        if time.contents === 0 {
          clearInterval(interval.contents)
        }
      }, 1000)
  }

  let updateAnswer = (question, player, answer) => {
    FastMoney.updateAnswer(props.game, question, player, answer)->props.updateGame
  }

  let selectAnswer = (question, player, data) => {
    let oldAnswer = FastMoney.Question.getAnswer(question, player)
    let newAnswer = {...oldAnswer, text: fst(data), count: snd(data)}

    if newAnswer.text === question.answerPlayer1.text {
      Broadcaster.InvalidAnswer->Broadcaster.sendEvent
    } else {
      updateAnswer(question, player, newAnswer)->ignore
    }
  }

  let revealAnswerText = (question, player, answer) => {
    updateAnswer(question, player, answer)
    ->FastMoney
    ->Broadcaster.RevealAnswerText
    ->Broadcaster.sendEvent
  }

  let revealAnswerCount = (question, player, answer) => {
    let updated = updateAnswer(question, player, answer)

    Broadcaster.RevealAnswerCount(FastMoney(updated), answer.count)->Broadcaster.sendEvent
  }

  let points = FastMoney.getPoints(props.game)

  <>
    <div> {React.string(`Punkte: ${Int.toString(points)}`)} </div>
    <div className=Styles.timer>
      {switch props.game.timerPlayer1 {
      | Hidden(time) =>
        <button onClick={_ => startTimer(Player1)}>
          {React.string(`Timer Spieler 1 starten (${Int.toString(time)})`)}
        </button>
      | Visible(time) => <span> {React.string(`Timer Spieler 1: ${Int.toString(time)}`)} </span>
      }}
      {switch props.game.timerPlayer2 {
      | Hidden(time) =>
        <button onClick={_ => startTimer(Player2)}>
          {React.string(`Timer Spieler 2 starten (${Int.toString(time)})`)}
        </button>
      | Visible(time) => <span> {React.string(`Timer Spieler 2: ${Int.toString(time)}`)} </span>
      }}
    </div>
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
            <Answers
              answers=question.answers
              select={(player, data) => selectAnswer(question, player, data)}
            />
            <PlayerInputs
              answer=question.answerPlayer1
              update={answer => updateAnswer(question, Player1, answer)->ignore}
              revealText={revealAnswerText(question, Player1)}
              revealCount={revealAnswerCount(question, Player1)}
            />
            <PlayerInputs
              answer=question.answerPlayer2
              update={answer => updateAnswer(question, Player2, answer)->ignore}
              revealText={revealAnswerText(question, Player2)}
              revealCount={revealAnswerCount(question, Player2)}
            />
          </tr>
        )
        ->React.array}
      </tbody>
    </table>
  </>
}
