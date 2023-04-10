type sound = [#reveal | #fail]

let play: sound => unit = %raw(`
  function (sound) {
    new Audio("/" + sound + ".ogg").play();
  }
`)
