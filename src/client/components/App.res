type app = Configurator | Game | GameController(Config.t)

module Styles = {
  open Emotion

  let container = css(`
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    margin-bottom: 0.5rem;

    > label {
      &[disabled] {
        opacity: 0.5;
        pointer-events: none;
      }

      > span {
        margin: 0 0.5rem;
      }
    }
  `)
}

let stringToBool = string =>
  switch string {
  | "true" => true
  | "false" => false
  | _ => panic("invalid value")
  }

@react.component
let make = () => {
  let (app, setApp) = React.useState(_ => None)

  let (useMultipleDevices, setUseMultipleDevices) = React.useState(_ =>
    Dom.Storage2.localStorage
    ->Dom.Storage2.getItem("useMultipleDevices")
    ->Option.getWithDefault("false")
    ->stringToBool
  )

  let (serverUrl, setServerUrl) = React.useState(_ =>
    Dom.Storage2.localStorage->Dom.Storage2.getItem("serverUrl")->Option.getWithDefault("")
  )

  let setConfig = config => {
    setApp(_ => Some(GameController(config)))
  }

  let toggleMultipleDevices = e => {
    let checked = ReactEvent.Form.target(e)["checked"]

    setUseMultipleDevices(_ => checked)
    Dom.Storage2.localStorage->Dom.Storage2.setItem("useMultipleDevices", checked)
  }

  let changeIP = e => {
    let input = ReactEvent.Form.target(e)["value"]

    setServerUrl(_ => input)
    Dom.Storage2.localStorage->Dom.Storage2.setItem("serverUrl", input)
  }

  let bcOptions = switch useMultipleDevices {
  | true => Broadcaster.ServerSendEvent(serverUrl)
  | false => Broadcaster.BroadcastChannel("familienduell")
  }

  switch app {
  | Some(Configurator) => <Configurator setConfig />
  | Some(Game) => <GameApp bcOptions />
  | Some(GameController(config)) => <GameController config bcOptions />
  | None =>
    <>
      <div className=Styles.container>
        <label>
          <input type_="checkbox" checked=useMultipleDevices onChange=toggleMultipleDevices />
          <span> {React.string("verschiedene Geräte aktivieren")} </span>
        </label>
        <label
          disabled={switch bcOptions {
          | BroadcastChannel(_) => true
          | ServerSendEvent(_) => false
          }}>
          <span> {React.string("Endpunkt:")} </span>
          <input value=serverUrl placeholder="http://192.168.0.100:8000" onChange=changeIP />
        </label>
      </div>
      <Button onClick={_ => setApp(_ => Some(Configurator))}>
        {React.string("Controller öffnen")}
      </Button>
      <Button onClick={_ => setApp(_ => Some(Game))}> {React.string("Monitor öffnen")} </Button>
    </>
  }
}
