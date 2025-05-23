type app = Configurator | Game | GameController(Config.t)

@react.component
let make = () => {
  let (app, setApp) = React.useState(_ => None)

  let setConfig = config => {
    setApp(_ => Some(GameController(config)))
  }

  switch app {
  | Some(Configurator) => <Configurator setConfig />
  | Some(Game) => <GameApp />
  | Some(GameController(config)) => <GameController config />
  | None =>
    <>
      <Button onClick={_ => setApp(_ => Some(Configurator))}>
        {React.string("Controller öffnen")}
      </Button>
      <Button onClick={_ => setApp(_ => Some(Game))}> {React.string("Monitor öffnen")} </Button>
    </>
  }
}
