type t = FaceOff(FaceOff.t) // | FastMoney(fastMoney)

let make = questionIndex => {
  let numberOfAnswers = FaceOff.getNumberOfAnswers(Round1)
  let question = Question.make(TestData.questions[questionIndex]->Option.getExn, numberOfAnswers)

  FaceOff.make(Round1, question)->FaceOff
}

let nextRound = (game, questionIndex, winner: Team.choice) => {
  switch game {
  | FaceOff(faceOff) => {
      let maybeNextRound = FaceOff.getNextRound(faceOff.round)

      switch maybeNextRound {
      | Some(nextRound) => {
          let pointsToAdd = FaceOff.getPointsWithMultiplicator(faceOff)

          let pointsPerTeam = switch winner {
          | Team1 => (faceOff.team1.points + pointsToAdd, faceOff.team2.points)
          | Team2 => (faceOff.team1.points, faceOff.team2.points + pointsToAdd)
          }

          let numberOfAnswers = FaceOff.getNumberOfAnswers(nextRound)

          let question = Question.make(
            TestData.questions[questionIndex]->Option.getExn,
            numberOfAnswers,
          )

          FaceOff({
            round: nextRound,
            question,
            points: 0,
            team1: pointsPerTeam->fst->Team.makeWithPoints,
            team2: pointsPerTeam->snd->Team.makeWithPoints,
          })
        }
      | None => panic("not implemented yet")
      }
    }
  }
}
