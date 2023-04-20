type t = Intro | FaceOff(FaceOff.t) | FastMoney(FastMoney.t)

// let make = questionIndex => {
//   let question = Question.make(TestData.questions[questionIndex]->Option.getExn, 5)

//   FaceOff.make(question, 1)->FaceOff
// }

let nextRound = (game, questionIndex, winner: Team.choice) => {
  // switch game {
  // | FaceOff(faceOff) => {
  //     let maybeNextRound = FaceOff.getNextRound(faceOff.round)

  //     switch maybeNextRound {
  //     | Some(nextRound) => {
  //         let pointsToAdd = FaceOff.getPointsWithMultiplicator(faceOff)

  //         let pointsPerTeam = switch winner {
  //         | Team1 => (faceOff.team1.points + pointsToAdd, faceOff.team2.points)
  //         | Team2 => (faceOff.team1.points, faceOff.team2.points + pointsToAdd)
  //         }

  //         let numberOfAnswers = FaceOff.getNumberOfAnswers(nextRound)

  //         let question = Question.make(
  //           TestData.questions[questionIndex]->Option.getExn,
  //           numberOfAnswers,
  //         )

  //         FaceOff({
  //           round: nextRound,
  //           question,
  //           points: 0,
  //           team1: pointsPerTeam->fst->Team.makeWithPoints,
  //           team2: pointsPerTeam->snd->Team.makeWithPoints,
  //         })
  //       }
  //     | None => panic("not implemented yet")
  //     }
  //   }
  // }

  Obj.magic()
}
