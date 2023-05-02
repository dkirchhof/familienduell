type t =
  | Intro(string)
  | FaceOffIntro(FaceOff.t)
  | FaceOff(FaceOff.t)
  | FastMoneyIntro(string)
  | FastMoney(FastMoney.t)
