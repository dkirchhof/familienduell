@react.component
let make = () => {
  let gameIndex = React.useRef(0)
  let questionIndex = React.useRef(0)

  let (game, updateGame) = SimpleState.use(Game.Intro)

  let next = () => {
    let nextConfig = Config.config.games[gameIndex.current]->Option.getExn

    switch (game, nextConfig) {
    | (Intro, FaceOff(faceOffConfig)) => {
        let question = Question.make(
          TestData.questions[questionIndex.current]->Option.getExn,
          faceOffConfig.answers,
        )

        let nextGame = FaceOff.make(question, faceOffConfig.multiplicator)

        nextGame->FaceOffIntro->updateGame->Broadcaster.Sync->Broadcaster.sendEvent

        setTimeout(() => {
          nextGame->FaceOff->updateGame->Broadcaster.Sync->Broadcaster.sendEvent
        }, 4000)->ignore

        questionIndex.current = questionIndex.current + 1
      }
    | (FaceOff(prevFaceOff), FaceOff(faceOffConfig)) => {
        Console.log("next")
        let question = Question.make(
          TestData.questions[questionIndex.current]->Option.getExn,
          faceOffConfig.answers,
        )

        let nextGame = {
          ...prevFaceOff,
          question,
          multiplicator: faceOffConfig.multiplicator,
          team1: Team.makeWithPoints(prevFaceOff.team1.points),
          team2: Team.makeWithPoints(prevFaceOff.team2.points),
        }

        nextGame->FaceOffIntro->updateGame->Broadcaster.Sync->Broadcaster.sendEvent

        setTimeout(() => {
          nextGame->FaceOff->updateGame->Broadcaster.Sync->Broadcaster.sendEvent
        }, 4000)->ignore

        questionIndex.current = questionIndex.current + 1
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

  switch game {
  | Intro => <IntroController next />
  | FaceOffIntro(_) => <FaceOffIntroController />
  | FaceOff(faceOff) => <FaceOffController game=faceOff updateGame=updateFaceOff next />
  | FastMoney(fastMoney) => <FastMoneyController game=fastMoney updateGame=updateFastMoney />
  }
}
