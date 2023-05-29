type file = [
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

let play: (file, option<int>) => unit = %raw(`
  function (file, time) {
    const audio = new Audio("/assets/sounds/" + file + ".ogg");

    audio.play();

    if (time) {
      setTimeout(() => audio.pause(), time);
    }
  }
`)
