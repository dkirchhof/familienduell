type t = {
  text: string,
  count: int,
  revealed: bool,
}

let make = (text, count) => {
  text,
  count,
  revealed: false,
}

let reveal = answer => {...answer, revealed: true}
