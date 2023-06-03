module Styles = {
  open Emotion

  let container = css(
    `
    display: grid;
    grid-template-rows: 1fr 1.5rem;

    > main {
      padding: 1rem;

      display: grid;
      grid-template-columns: 1fr 1.3rem 1.3rem 1fr;
      gap: 0.25rem;
      align-items: center;

      font-size: 1.05rem;
      line-height: 1.25;
    }

    > footer {
      padding: 0 1rem;

      display: grid;
      grid-template-columns: 4rem 1fr 4rem;

      color: ${Theme.Colors.get(#primary)};
      background: ${Theme.Colors.get(#secondary)};

      font-size: 1.5rem;

      > div {
        text-align: center;
      }
    }
  `,
  )

  let answerPlayer1Text = css(
    `
    view-transition-name: answer-player-1-text;
    contain: paint;

    background: ${Theme.Colors.get(#primary)};

    text-align: right;
  `,
  )

  let answerPlayer1Count = css(`
    text-align: right;
  `)

  let answerPlayer2Count = css(`
    text-align: right;
  `)

  let answerPlayer2Text = css(
    `
    view-transition-name: answer-player-2-text;
    contain: paint;

    background: ${Theme.Colors.get(#primary)};

    text-align: left;
  `,
  )
}

module AnswerTexts = {
  type props = {
    className: string,
    questions: array<FastMoney.Question.t>,
    getAnswer: FastMoney.Question.t => FastMoney.Answer.t,
  }

  let make = props => {
    <div className=props.className>
      {props.questions
      ->Array.mapWithIndex((question, i) => {
        let answer = props.getAnswer(question)
        let text = if answer.textRevealed {
          if answer.text === "" {
            "-----"
          } else {
            String.slice(answer.text, ~start=0, ~end=15)
          }
        } else {
          String.repeat("_", 15)
        }

        <div key={Int.toString(i)}> {React.string(text)} </div>
      })
      ->React.array}
    </div>
  }
}

module AnswerCounts = {
  type props = {
    className: string,
    questions: array<FastMoney.Question.t>,
    getAnswer: FastMoney.Question.t => FastMoney.Answer.t,
  }

  let make = props => {
    <div className=props.className>
      {props.questions
      ->Array.mapWithIndex((question, i) => {
        let answer = props.getAnswer(question)
        let text = answer.countRevealed ? Int.toString(answer.count) : "--"

        <div key={Int.toString(i)}> {React.string(text)} </div>
      })
      ->React.array}
    </div>
  }
}

type props = {fastMoney: FastMoney.t}

let make = (props: props) => {
  let sum = FastMoney.getPoints(props.fastMoney)

  <div className=Styles.container>
    <main>
      <AnswerTexts
        className=Styles.answerPlayer1Text
        questions=props.fastMoney.questions
        getAnswer={q => q.answerPlayer1}
      />
      <AnswerCounts
        className=Styles.answerPlayer1Count
        questions=props.fastMoney.questions
        getAnswer={q => q.answerPlayer1}
      />
      <AnswerCounts
        className=Styles.answerPlayer2Count
        questions=props.fastMoney.questions
        getAnswer={q => q.answerPlayer2}
      />
      <AnswerTexts
        className=Styles.answerPlayer2Text
        questions=props.fastMoney.questions
        getAnswer={q => q.answerPlayer2}
      />
    </main>
    <footer>
      <div>
        {switch props.fastMoney.timerPlayer1 {
        | Visible(time) => time->Int.toString->React.string
        | Hidden(_) => React.null
        }}
      </div>
      <div> {sum->Int.toString->React.string} </div>
      <div>
        {switch props.fastMoney.timerPlayer2 {
        | Visible(time) => time->Int.toString->React.string
        | Hidden(_) => React.null
        }}
      </div>
    </footer>
    <audio src="/assets/sounds/revealText.ogg" autoPlay=true />
  </div>
}
