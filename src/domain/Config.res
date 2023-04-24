@tag("type")
type gameConfig =
  | @as("faceOff") FaceOffConfig({answers: int, multiplicator: [#1 | #2 | #3]})
  | @as("fastMoney") FastMoneyConfig({questions: int})

type rawQuestion = {text: string, answers: array<(string, int)>}

type t = {
  @as("firstQuestion") firstQuestionIndex: int,
  @as("games") gameConfigs: array<gameConfig>,
  questions: array<rawQuestion>,
}

let load = () => {
  let config: t = %raw(`window.config`)

  let rec mapConfig = (configs, questionIndex, games) => {
    switch configs[0] {
    | Some(FaceOffConfig(faceOffConfig)) => {
        let rawQuestion = config.questions[questionIndex]->Option.getExn

        let question = FaceOff.Question.make(
          rawQuestion.text,
          rawQuestion.answers,
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
          config.questions
          ->Array.slice(~start=questionIndex, ~end=questionIndex + fastMoneyConfig.questions)
          ->Array.map(rawQuestion => FastMoney.Question.make(rawQuestion.text, rawQuestion.answers))

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

  mapConfig(config.gameConfigs, config.firstQuestionIndex, [])
}
