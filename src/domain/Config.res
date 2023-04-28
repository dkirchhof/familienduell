@tag("type")
type gameConfig =
  | @as("faceOff") FaceOffConfig({answers: int, multiplicator: [#1 | #2 | #3]})
  | @as("fastMoney") FastMoneyConfig({questions: int, timePlayer1: int, timePlayer2: int})

type rawQuestion = {text: string, answers: array<(string, int)>}

type raw = {
  name: string,
  firstQuestionIndex: int,
  gameConfigs: array<gameConfig>,
  questions: array<rawQuestion>,
}

type t = {
  name: string,
  games: array<Game.t>,
}

let load = () => {
  let config: raw = %raw(`window.config`)

  let rec mapGameConfig = (configs, questionIndex, games) => {
    switch configs[0] {
    | Some(FaceOffConfig(faceOffConfig)) => {
        let rawQuestion = config.questions[questionIndex]->Option.getExn

        let question = FaceOff.Question.make(
          rawQuestion.text,
          rawQuestion.answers,
          faceOffConfig.answers,
        )

        let game = FaceOff.make(question, faceOffConfig.multiplicator)->Game.FaceOff

        mapGameConfig(
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

        let game =
          FastMoney.make(
            questions,
            fastMoneyConfig.timePlayer1,
            fastMoneyConfig.timePlayer2,
          )->Game.FastMoney

        mapGameConfig(
          Array.sliceToEnd(configs, ~start=1),
          questionIndex + fastMoneyConfig.questions,
          Array.concat(games, [game]),
        )
      }
    | None => games
    }
  }

  {
    name: config.name,
    games: mapGameConfig(config.gameConfigs, config.firstQuestionIndex, []),
  }
}
