@react.component
let make = () => {
  let (game, setGame) = React.useState(_ => Game.make())

  React.useEffect1(() => {
    Broadcaster.Reveal(game)->Broadcaster.sendEvent

    None
  }, [game])

  let sync = () => {
    Broadcaster.Sync(game)->Broadcaster.sendEvent
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
