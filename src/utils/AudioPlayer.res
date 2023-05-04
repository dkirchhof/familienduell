type sound = [
  | #revealText
  | #revealCount
  | #revealBoth
  | #fail
  | #fail2
  | #timerEnd
  | #endFaceOff
  | #winFastMoney
  | #looseFastMoney
]

let play: sound => unit = %raw(`
  function (sound) {
    new Audio("/assets/sounds/" + sound + ".ogg").play();
  }
`)
