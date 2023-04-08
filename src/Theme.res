let var = name => `var(--${name})`
let makeVar = (name, value) => `--${name}: ${value}`

module Colors = {
  type keys = [
    | #primary
    | #secondary
    | #tertiary
    | #accent
  ]

  let get = (name: keys) => var((name :> string))
  let set = (name: keys, value) => makeVar((name :> string), value)
}
