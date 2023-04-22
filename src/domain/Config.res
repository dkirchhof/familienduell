@tag("type")
type gameConfig =
  | @as("faceOff") FaceOffConfig({answers: int, multiplicator: [#1 | #2 | #3]})
  | @as("fastMoney") FastMoneyConfig({questions: int})

type t = {
  games: array<gameConfig>
}

external config: t = "config"
