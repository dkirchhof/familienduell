type t = FaceOff(FaceOff.t) // | FastMoney(fastMoney)

let make = () => FaceOff.make(Round1, TestData.questions[0]->Option.getExn)->FaceOff

let nextRound = (game, winner: Team.choice) => {
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

          FaceOff({
            round: nextRound,
            question: TestData.questions[0]->Option.getExn,
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
