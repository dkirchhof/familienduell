@tag("type")
type gameConfig =
  | @as("faceOff") FaceOffConfig({answers: int, multiplicator: [#1 | #2 | #3]})
  | @as("fastMoney") FastMoneyConfig({questions: int})

type t = {games: array<gameConfig>}

let load = (firstQuestionIndex: int) => {
  let rec mapConfig = (configs, questionIndex, games) => {
    switch configs[0] {
    | Some(FaceOffConfig(faceOffConfig)) => {
        let question = FaceOff.Question.make(
          TestData.questions[questionIndex]->Option.getExn,
          faceOffConfig.answers,
        )

        let game = FaceOff.make(question, faceOffConfig.multiplicator)->Game.FaceOff

        mapConfig(
          Array.sliceToEnd(configs, ~start=1),
          questionIndex + 1,
          Array.concat(games, [game]),
        )
      }

    | Some(FastMoneyConfig(fastMoneyConfig)) => {
        let questions =
          TestData.questions
          ->Array.slice(~start=questionIndex, ~end=questionIndex + fastMoneyConfig.questions)
          ->Array.map(FastMoney.Question.make)

        let game = FastMoney.make(questions)->Game.FastMoney

        mapConfig(
          Array.sliceToEnd(configs, ~start=1),
          questionIndex + fastMoneyConfig.questions,
          Array.concat(games, [game]),
        )
      }
    | None => games
    }
  }

  mapConfig(%raw(`window.config.games`), firstQuestionIndex, [])
}
