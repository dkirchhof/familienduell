type file = [#reveal | #fail]

let play: file => unit = %raw(`
  function (file) {
    new Audio("/" + file + ".ogg").play();
  }
`)
