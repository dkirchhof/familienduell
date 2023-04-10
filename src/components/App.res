type app = Game | Controller

@react.component
let make = () => {
  /* let (app, setApp) = React.useState(_ => None) */
  /* let (app, setApp) = React.useState(_ => Some(Game)) */
  let (app, setApp) = React.useState(_ => Some(Controller))

  switch app {
  | Some(Game) => <GameApp />
  | Some(Controller) => <ControllerApp />
  | None =>
    <>
      <button onClick={_ => setApp(_ => Some(Game))}> {React.string("Spiel")} </button>
      <button onClick={_ => setApp(_ => Some(Controller))}> {React.string("Controller")} </button>
    </>
  }
}
