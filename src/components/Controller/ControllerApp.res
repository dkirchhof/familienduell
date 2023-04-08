@react.component
let make = () => {
  let (game, setGame) = React.useState(_ => Game.make())

  let updateFaceOff = faceOff => {
    setGame(_ => FaceOff(faceOff))
  }

  let nextRound = winner => {
    setGame(_ => Game.nextRound(game, winner))
  }

  switch game {
  | FaceOff(faceOff) => <FaceOffController faceOff update=updateFaceOff nextRound />
  }
}
