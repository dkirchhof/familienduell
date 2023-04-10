type app = Game | Controller

@react.component
let make = () => {
  let (app, setApp) = React.useState(_ => None)

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
