type round = Round1 | Round2 | Round3 | Round4

type t = {round: round, question: Question.t, points: int, team1: Team.t, team2: Team.t}

let make = (question) => {
  round: Round1,
  question,
  points: 0,
  team1: Team.make(),
  team2: Team.make(),
}

let getNextRound = round =>
  switch round {
  | Round1 => Some(Round2)
  | Round2 => Some(Round3)
  | Round3 => Some(Round4)
  | Round4 => None
  }

let getMultiplicator = faceOff => {
  switch faceOff.round {
  | Round1 | Round2 => 1
  | Round3 => 2
  | Round4 => 3
  }
}

let getNumberOfAnswers = round => {
  switch round {
  | Round1 => 6
  | Round2 => 5
  | Round3 => 4
  | Round4 => 3
  }
}

let getPointsWithMultiplicator = faceOff => {
  faceOff.points * getMultiplicator(faceOff)
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
  | Team.Team1 => {...faceOff, team1: Team.lock(faceOff.team1)}
  | Team.Team2 => {...faceOff, team2: Team.lock(faceOff.team2)}
  }

let unlockTeam = (faceOff, team) =>
  switch team {
  | Team.Team1 => {...faceOff, team1: Team.unlock(faceOff.team1)}
  | Team.Team2 => {...faceOff, team2: Team.unlock(faceOff.team2)}
  }

let addStrike = (faceOff, team) =>
  switch team {
  | Team.Team1 => {...faceOff, team1: Team.addStrike(faceOff.team1)}
  | Team.Team2 => {...faceOff, team2: Team.addStrike(faceOff.team2)}
  }
