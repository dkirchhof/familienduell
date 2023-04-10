type sound = [#revealText | #revealCount | #revealBoth | #fail]

let play: sound => unit = %raw(`
  function (sound) {
    new Audio("/" + sound + ".ogg").play();
  }
`)
