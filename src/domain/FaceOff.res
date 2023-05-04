module Answer = {
  type t = {
    text: string,
    count: int,
    revealed: bool,
  }

  let make = (text, count) => {
    text: StringUtils.replaceAll(text, "ß", "ss"),
    count,
    revealed: false,
  }

  let reveal = answer => {...answer, revealed: true}
}

module Question = {
  type t = {
    text: string,
    answers: array<Answer.t>,
  }

  let make = (question: string, answers: array<(string, int)>, numberOfAnswers) => {
    text: question,
    answers: answers
    ->Array.sort(((_, countA), (_, countB)) => countB - countA)
    ->Array.slice(~start=0, ~end=numberOfAnswers)
    ->Array.map(((text, count)) => Answer.make(text, count)),
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
}

type multiplicator = [#1 | #2 | #3]

type t = {
  question: Question.t,
  points: int,
  multiplicator: multiplicator,
  teamBlue: Team.t,
  teamRed: Team.t,
}

let make = (question, multiplicator) => {
  question,
  points: 0,
  multiplicator,
  teamBlue: Team.make(),
  teamRed: Team.make(),
}

let getPointsWithMultiplicator = faceOff => {
  faceOff.points * (faceOff.multiplicator :> int)
}

let revealAnswer = (faceOff, answer) => {
  ...faceOff,
  question: Question.revealAnswer(faceOff.question, answer),
}

let selectAnswer = (faceOff, answer) => {
  ...revealAnswer(faceOff, answer),
  points: faceOff.points + answer.count,
}

let lockTeam = (faceOff, team) =>
  switch team {
  | Team.TeamBlue => {...faceOff, teamBlue: Team.lock(faceOff.teamBlue)}
  | Team.TeamRed => {...faceOff, teamRed: Team.lock(faceOff.teamRed)}
  }

let unlockTeam = (faceOff, team) =>
  switch team {
  | Team.TeamBlue => {...faceOff, teamBlue: Team.unlock(faceOff.teamBlue)}
  | Team.TeamRed => {...faceOff, teamRed: Team.unlock(faceOff.teamRed)}
  }

let addStrike = (faceOff, team) =>
  switch team {
  | Team.TeamBlue => {...faceOff, teamBlue: Team.addStrike(faceOff.teamBlue)}
  | Team.TeamRed => {...faceOff, teamRed: Team.addStrike(faceOff.teamRed)}
  }

let endRound = (faceOff, winner) =>
  switch winner {
  | Team.TeamBlue => {
      ...faceOff,
      points: 0,
      teamBlue: Team.addPoints(faceOff.teamBlue, getPointsWithMultiplicator(faceOff)),
    }
  | Team.TeamRed => {
      ...faceOff,
      points: 0,
      teamRed: Team.addPoints(faceOff.teamRed, getPointsWithMultiplicator(faceOff)),
    }
  }
