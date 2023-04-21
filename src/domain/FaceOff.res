type multiplicator = [#1 | #2 | #3]

type t = {
  question: Question.t,
  points: int,
  multiplicator: multiplicator,
  team1: Team.t,
  team2: Team.t,
}

let make = (question, multiplicator) => {
  question,
  points: 0,
  multiplicator,
  team1: Team.make(),
  team2: Team.make(),
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

let endRound = (faceOff, winner) =>
  switch winner {
  | Team.Team1 => {
      ...faceOff,
      points: 0,
      team1: Team.addPoints(faceOff.team1, getPointsWithMultiplicator(faceOff)),
    }
  | Team.Team2 => {
      ...faceOff,
      points: 0,
      team2: Team.addPoints(faceOff.team2, getPointsWithMultiplicator(faceOff)),
    }
  }
