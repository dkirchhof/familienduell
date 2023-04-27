let use = value => {
  let (state, setState) = React.useState(_ => value)

  let update = newValue => {
    setState(_ => newValue)

    newValue
  }
  
  (state, update, setState)
}
