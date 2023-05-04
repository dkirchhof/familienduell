type sound = [
  | #credits
  | #faceOffIntro
  | #faceOffOutro
  | #fail
  | #fastMoneyIntro
  | #fastMoneyInvalid
  | #fastMoneyLoose
  | #fastMoneyOutro
  | #fastMoneyWin
  | #intro
  | #revealBoth
  | #revealCount
  | #revealText
  | #timer
  | #timerEnd
]

let play: sound => unit = %raw(`
  function (sound) {
    new Audio("/assets/sounds/" + sound + ".ogg").play();
  }
`)
