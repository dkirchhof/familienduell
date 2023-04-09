type t = {
  text: string,
  answers: array<Answer.t>,
}

let make = (data: TestData.question, numberOfAnswers) => {
  text: data.text,
  answers: data.answers
  ->Array.slice(~start=0, ~end=numberOfAnswers)
  ->Array.map(a => Answer.make(a.text, a.count)),
}

let revealAnswer = (question, answer) => {
  ...question,
  answers: question.answers->Array.map(a => {
    if a === answer {
      Answer.reveal(a)
    } else {
      a
    }
  }),
}
