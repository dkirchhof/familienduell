@react.component
let make = () => {
  let gameIndex = React.useRef(0)
  let questionIndex = React.useRef(0)

  let (game, updateGame) = SimpleState.use(Game.Intro)

  let next = () => {
    let nextConfig = Config.config.games[gameIndex.current]->Option.getExn

    switch (game, nextConfig) {
    | (Intro, FaceOff(faceOff)) => {
        let question = Question.make(
          TestData.questions[questionIndex.current]->Option.getExn,
          faceOff.answers,
        )

        FaceOff.make(question, faceOff.multiplicator)
        ->FaceOff
        ->updateGame
        ->Broadcaster.Sync
        ->Broadcaster.sendEvent
      }
    | _ => panic("not implemented")
    }

    gameIndex.current = mod(gameIndex.current + 1, Array.length(Config.config.games))
  }

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
    // questionIndex.current = questionIndex.current + 1

    // Game.nextRound(game, questionIndex.current, winner)
    // ->updateGame
    // ->Broadcaster.Sync
    // ->Broadcaster.sendEvent
    Obj.magic()
  }

  switch game {
  | Intro => <IntroController next />
  | FaceOff(faceOff) => <FaceOffController game=faceOff updateGame=updateFaceOff nextRound />
  | FastMoney(fastMoney) => <FastMoneyController game=fastMoney updateGame=updateFastMoney />
  }
}
