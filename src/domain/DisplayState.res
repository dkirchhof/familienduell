type t =
  | Blank
  | Intro(string)
  | FaceOffIntro(FaceOff.multiplicator)
  | FaceOffGame(FaceOff.t)
  | FastMoneyIntro(string)
  | FastMoneyGame(FastMoney.t)
  | Outro
