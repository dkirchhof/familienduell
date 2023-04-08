type t = {
  text: string,
  answers: array<Answer.t>,
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
