type t = {
  text: string,
  count: int,
  revealed: bool,
}

let reveal = answer => {...answer, revealed: true}
