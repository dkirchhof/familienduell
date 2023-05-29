@tag("type")
type gameConfig =
  | @as("faceOff") FaceOffConfig({answers: int, multiplicator: [#1 | #2 | #3]})
  | @as("fastMoney") FastMoneyConfig({name: string, questions: int, timePlayer1: int, timePlayer2: int})

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

let exampleConfig = JSON.stringifyAnyWithIndent(
  {
    name: "Familienduell",
    firstQuestionIndex: 0,
    gameConfigs: [
      FaceOffConfig({answers: 8, multiplicator: #1}),
      FastMoneyConfig({name: "Finale", questions: 5, timePlayer1: 20, timePlayer2: 25}),
    ],
    questions: [
      {
        text: "Nennen Sie eine Farbe",
        answers: [
          ("Blau", 35),
          ("Rot", 23),
          ("Grün", 20),
          ("Gelb", 6),
          ("Schwarz", 4),
          ("Türkis", 3),
          ("Braun", 2),
          ("Hier steht eine sehr lange Antwort", 1),
        ],
      },
      {
        text: "Nennen Sie eine Zahl",
        answers: [
          ("Achtzig", 80),
          ("Neun", 9),
          ("Eins", 4),
          ("Null", 3),
          ("Sieben", 2),
          ("Neunundsechzig", 1),
        ],
      },
    ],
  },
  2,
)->Option.getExn

let parseJson = (json: string) => {
  open RescriptStruct

  let codec = S.object(o => {
    name: S.field(o, "name", S.string()),
    firstQuestionIndex: S.field(o, "firstQuestionIndex", S.int()),
    gameConfigs: S.field(
      o,
      "gameConfigs",
      S.array(
        S.union([
          S.object(o => {
            S.field(o, "type", S.literal(String("faceOff")))->ignore

            FaceOffConfig({
              answers: S.field(o, "answers", S.int()),
              multiplicator: S.field(
                o,
                "multiplicator",
                S.union([
                  S.literalVariant(Int(1), #1),
                  S.literalVariant(Int(2), #2),
                  S.literalVariant(Int(3), #3),
                ]),
              ),
            })
          }),
          S.object(o => {
            S.field(o, "type", S.literal(String("fastMoney")))->ignore

            FastMoneyConfig({
              name: S.field(o, "name", S.string()),
              questions: S.field(o, "questions", S.int()),
              timePlayer1: S.field(o, "timePlayer1", S.int()),
              timePlayer2: S.field(o, "timePlayer2", S.int()),
            })
          }),
        ]),
      ),
    ),
    questions: S.field(
      o,
      "questions",
      S.array(
        S.object(o => {
          text: S.field(o, "text", S.string()),
          answers: S.field(o, "answers", S.array(S.tuple2(S.string(), S.int()))),
        }),
      ),
    ),
  })
  
  S.parseJsonWith(json, codec)
}

let loadFromJson = json => {
  let parsedJson = parseJson(json)

  switch parsedJson {
  | Ok(rawConfig) => {
      let rec mapGameConfig = (configs, questionIndex, games) => {
        switch configs[0] {
        | Some(FaceOffConfig(faceOffConfig)) => {
            let rawQuestion = rawConfig.questions[questionIndex]->Option.getExn

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
              rawConfig.questions
              ->Array.slice(~start=questionIndex, ~end=questionIndex + fastMoneyConfig.questions)
              ->Array.map(rawQuestion =>
                FastMoney.Question.make(rawQuestion.text, rawQuestion.answers)
              )

            let game =
              FastMoney.make(
                fastMoneyConfig.name,
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

      Ok({
        name: rawConfig.name,
        games: mapGameConfig(rawConfig.gameConfigs, rawConfig.firstQuestionIndex, []),
      })
    }
  | Error(_) as e => e
  }
}
