@react.component
let make = () => {
  let questionIndex = React.useRef(0)

  let (game, updateGame) = SimpleState.use(Game.make(questionIndex.current))

  React.useEffect0(() => {
    Broadcaster.Sync(game)->Broadcaster.sendEvent

    None
  })

  let updateFaceOff = faceOff => {
    faceOff->FaceOff->updateGame->ignore

    faceOff
  }

  let updateFastMoney = fastMoney => {
    fastMoney->FastMoney->updateGame->ignore

    fastMoney
  }

  let nextRound = winner => {
    questionIndex.current = questionIndex.current + 1

    Game.nextRound(game, questionIndex.current, winner)
    ->updateGame
    ->Broadcaster.Sync
    ->Broadcaster.sendEvent
  }

  switch game {
  | FaceOff(faceOff) => <FaceOffController game=faceOff updateGame=updateFaceOff nextRound />
  | FastMoney(fastMoney) => <FastMoneyController game=fastMoney updateGame=updateFastMoney />
  }
}
