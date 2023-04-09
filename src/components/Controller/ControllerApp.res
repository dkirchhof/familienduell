@react.component
let make = () => {
  let questionIndex = React.useRef(0)

  let (game, updateGame) = SimpleState.use(Game.make(questionIndex.current))

  React.useEffect0(() => {
    switch game {
    | FaceOff(faceOff) => Broadcaster.Sync(faceOff)->Broadcaster.sendEvent
    }

    None
  })

  let updateFaceOff = faceOff => {
    faceOff->FaceOff->updateGame->ignore

    faceOff
  }

  let nextRound = winner => {
    questionIndex.current = questionIndex.current + 1

    switch updateGame(Game.nextRound(game, questionIndex.current, winner)) {
    | FaceOff(faceOff) => Broadcaster.Sync(faceOff)->Broadcaster.sendEvent
    }
  }

  switch game {
  | FaceOff(faceOff) => <FaceOffController game=faceOff updateGame=updateFaceOff nextRound />
  }
}
