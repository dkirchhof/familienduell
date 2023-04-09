type file = [#reveal]

let play: file => unit = %raw(`
  function (file) {
    new Audio("/" + file + ".ogg").play();
  }
`)
