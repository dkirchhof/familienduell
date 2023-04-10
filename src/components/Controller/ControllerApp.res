@react.component
let make = () => {
  let questionIndex = React.useRef(0)

  let (game, updateGame) = SimpleState.use(Game.make(questionIndex.current))

  React.useEffect0(() => {
    switch game {
    | FaceOff(faceOff) => Broadcaster.Sync(faceOff)->Broadcaster.sendEvent
    /* | FastMoney(_) => panic("don't start with fast money") */
    | FastMoney(_) => ()
    }

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

    switch updateGame(Game.nextRound(game, questionIndex.current, winner)) {
    | FaceOff(faceOff) => Broadcaster.Sync(faceOff)->Broadcaster.sendEvent
    }
  }

  switch game {
  | FaceOff(faceOff) => <FaceOffController game=faceOff updateGame=updateFaceOff nextRound />
  | FastMoney(fastMoney) => <FastMoneyController game=fastMoney updateGame=updateFastMoney />
  }
}
