@react.component
let make = () => {
  let (game, setGame) = React.useState(_ => Game.make())

  React.useEffect1(() => {
    Broadcaster.UpdateGame(game)->Broadcaster.sendEvent

    None
  }, [game])

  let sync = () => {
    Broadcaster.UpdateGame(game)->Broadcaster.sendEvent
  }

  let updateFaceOff = faceOff => {
    setGame(_ => FaceOff(faceOff))
  }

  let nextRound = winner => {
    setGame(_ => Game.nextRound(game, winner))
  }

  <>
    <button onClick={_ => sync()}> {React.string("Synchronisieren")} </button>
    {switch game {
    | FaceOff(faceOff) => <FaceOffController faceOff update=updateFaceOff nextRound />
    }}
  </>
}
