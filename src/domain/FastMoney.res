type player = Player1 | Player2

module Answer = {
  type t = {
    text: string,
    count: int,
    textRevealed: bool,
    countRevealed: bool,
  }

  let make = () => {
    text: "",
    count: 0,
    textRevealed: false,
    countRevealed: false,
  }
}

module Question = {
  type t = {
    text: string,
    answers: array<TestData.answer>,
    answerPlayer1: Answer.t,
    answerPlayer2: Answer.t,
  }

  let make = (data: TestData.question) => {
    text: data.text,
    answers: data.answers,
    answerPlayer1: Answer.make(),
    answerPlayer2: Answer.make(),
  }

  let updateAnswer = (question, player, answer) => {
    switch player {
    | Player1 => {...question, answerPlayer1: answer}
    | Player2 => {...question, answerPlayer2: answer}
    }
  }
}

type t = {questions: array<Question.t>}

let make = questions => {
  questions: Array.map(questions, Question.make),
}

let updateAnswer = (game, question, player, answer) => {
  questions: Array.map(game.questions, q => {
    if q === question {
      Question.updateAnswer(q, player, answer)
    } else {
      q
    }
  }),
}

let getPoints = game => {
  Array.reduce(game.questions, 0, (acc, question) => {
    let a1 = question.answerPlayer1.countRevealed ? question.answerPlayer1.count : 0
    let a2 = question.answerPlayer2.countRevealed ? question.answerPlayer2.count : 0

    acc + a1 + a2
  })
}
