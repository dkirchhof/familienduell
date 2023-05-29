type player = Player1 | Player2

module Timer = {
  type t = Hidden(int) | Visible(int)

  let getTime = timer =>
    switch timer {
    | Hidden(time) | Visible(time) => time
    }
}

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
    answers: array<(string, int)>,
    answerPlayer1: Answer.t,
    answerPlayer2: Answer.t,
  }

  let make = (question: string, answers: array<(string, int)>) => {
    text: question,
    answers: answers->Array.sort(((_, countA), (_, countB)) => countB - countA),
    answerPlayer1: Answer.make(),
    answerPlayer2: Answer.make(),
  }

  let getAnswer = (question, player) => {
    switch player {
    | Player1 => question.answerPlayer1
    | Player2 => question.answerPlayer2
    }
  }

  let updateAnswer = (question, player, answer) => {
    switch player {
    | Player1 => {...question, answerPlayer1: answer}
    | Player2 => {...question, answerPlayer2: answer}
    }
  }
}

type t = {
  name: string,
  questions: array<Question.t>,
  timerPlayer1: Timer.t,
  timerPlayer2: Timer.t,
}

let make = (name, questions, timePlayer1, timePlayer2) => {
  name,
  questions,
  timerPlayer1: Hidden(timePlayer1),
  timerPlayer2: Hidden(timePlayer2),
}

let updateAnswer = (game, question, player, answer) => {
  ...game,
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

let getTimer = (game, player) => {
  switch player {
  | Player1 => game.timerPlayer1
  | Player2 => game.timerPlayer2
  }
}

let updateTimer = (game, player, timer) => {
  switch player {
  | Player1 => {...game, timerPlayer1: timer}
  | Player2 => {...game, timerPlayer2: timer}
  }
}
