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

  let buttons = css(`
    display: flex;
    gap: 0.5rem;
    align-items: center;
  `)

  let answer = css(`
    display: grid;
    grid-template-columns: 1fr 6rem 6rem;
    gap: 0.5rem;
  `)

  let invalidAnswer = css(`
    margin-top: 0.5rem;

    text-align: right;
    
    > button {
      width: 12.5rem;
    }
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
    invalidAnswer: unit => unit,
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
      <div className=Styles.invalidAnswer>
        <button onClick={_ => props.invalidAnswer()}> {React.string("Doppelte Antwort")} </button>
      </div>
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
  bcSender: Broadcaster.Sender.t,
  game: FastMoney.t,
  next: unit => unit,
}

let make = props => {
  let (game, setGame) = React.useState(_ => props.game)

  let broadcast = Broadcaster.Sender.sendEvent(props.bcSender, _)

  React.useEffect1(() => {
    setGame(_ => props.game)

    None
  }, [props.game])

  let updateDisplay = game => {
    broadcast(UpdateDisplay(FastMoneyGame(game)))
  }

  let updateDisplayAnimated = game => {
    broadcast(UpdateDisplayAnimated(FastMoneyGame(game)))
  }

  let playSound = sound => {
    broadcast(PlaySound(sound))
  }

  let playSoundLimited = (sound, time) => {
    broadcast(PlaySoundLimited(sound, time))
  }

  let startTimer = (player: FastMoney.player) => {
    let interval = ref(Obj.magic())
    let time = ref(0)

    setGame(g => {
      time := FastMoney.getTimer(g, player)->FastMoney.Timer.getTime

      let updatedGame = FastMoney.updateTimer(g, player, Visible(time.contents))

      updateDisplay(updatedGame)
      playSoundLimited(#timer, time.contents * 1000)

      updatedGame
    })

    interval := setInterval(() => {
        setGame(g => {
          time := time.contents - 1

          if time.contents === 0 {
            clearInterval(interval.contents)
            playSound(#timerEnd)
          }

          let updatedGame = FastMoney.updateTimer(g, player, Visible(time.contents))

          updateDisplay(updatedGame)

          updatedGame
        })
      }, 1000)
  }

  let invalidAnswer = () => {
    playSound(#fastMoneyInvalid)
  }

  let selectAnswer = (question, player, data) => {
    let oldAnswer = FastMoney.Question.getAnswer(question, player)
    let newAnswer = {...oldAnswer, text: fst(data), count: snd(data)}

    if newAnswer.text === question.answerPlayer1.text {
      playSound(#fastMoneyInvalid)
    } else {
      let updatedGame = FastMoney.updateAnswer(game, question, player, newAnswer)

      setGame(_ => updatedGame)
    }
  }

  let revealAnswerText = (question, player, answer) => {
    let updatedGame = FastMoney.updateAnswer(game, question, player, answer)

    setGame(_ => updatedGame)
    updateDisplayAnimated(updatedGame)
    playSound(#revealText)
  }

  let revealAnswerCount = (question, player, answer) => {
    let updatedGame = FastMoney.updateAnswer(game, question, player, answer)

    setGame(_ => updatedGame)
    updateDisplay(updatedGame)

    if answer.count > 0 {
      playSound(#revealCount)
    } else {
      playSound(#fail)
    }
  }

  let points = FastMoney.getPoints(game)

  <>
    <div> {React.string(`Punkte: ${Int.toString(points)}`)} </div>
    <div className=Styles.buttons>
      {switch game.timerPlayer1 {
      | Hidden(time) =>
        <button onClick={_ => startTimer(Player1)}>
          {React.string(`Timer Spieler 1 starten (${Int.toString(time)})`)}
        </button>
      | Visible(time) => <span> {React.string(`Timer Spieler 1: ${Int.toString(time)}`)} </span>
      }}
      {switch game.timerPlayer2 {
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
        {game.questions
        ->Array.mapWithIndex((question, i) =>
          <tr key={Int.toString(i)}>
            <th> {(i + 1)->Int.toString->React.string} </th>
            <th> {question.text->React.string} </th>
            <Answers
              answers=question.answers
              select={(player, data) => selectAnswer(question, player, data)}
              invalidAnswer
            />
            <PlayerInputs
              answer=question.answerPlayer1
              update={answer =>
                setGame(_ => FastMoney.updateAnswer(game, question, Player1, answer))}
              revealText={revealAnswerText(question, Player1, _)}
              revealCount={revealAnswerCount(question, Player1, _)}
            />
            <PlayerInputs
              answer=question.answerPlayer2
              update={answer =>
                setGame(_ => FastMoney.updateAnswer(game, question, Player2, answer))}
              revealText={revealAnswerText(question, Player2, _)}
              revealCount={revealAnswerCount(question, Player2, _)}
            />
          </tr>
        )
        ->React.array}
      </tbody>
    </table>
    <div className=Styles.buttons>
      <button onClick={_ => playSound(#fastMoneyWin)}> {React.string("Gewonnen")} </button>
      <button onClick={_ => playSound(#fastMoneyLoose)}> {React.string("Verloren")} </button>
      <button onClick={_ => props.next()}> {React.string("Nächste Runde")} </button>
    </div>
  </>
}
