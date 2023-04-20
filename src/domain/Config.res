@tag("type")
type gameConfig =
  | @as("faceOff") FaceOff({answers: int, multiplicator: [#1 | #2 | #3]})
  | @as("fastMoney") FastMoney({questions: int})

type t = {
  games: array<gameConfig>
}

external config: t = "config"
