@react.component
let make = () => {
  let games = Config.load()

  let (gameIndex, updateGameIndex) = SimpleState.use(0)
  let (game, updateGame) = SimpleState.use(Game.Intro)

  let next = () => {
    let nextGame = games[gameIndex]->Option.getExn

    switch (game, nextGame) {
    | (Intro, FaceOff(faceOff)) => {
        faceOff->FaceOffIntro->updateGame->Broadcaster.Sync->Broadcaster.sendEvent

        setTimeout(() => {
          faceOff->FaceOff->updateGame->Broadcaster.Sync->Broadcaster.sendEvent
        }, 4000)->ignore
      }
    | (FaceOff(prevFaceOff), FaceOff(nextFaceOff)) => {
        let nextFaceOff' = {
          ...nextFaceOff,
          team1: Team.makeWithPoints(prevFaceOff.team1.points),
          team2: Team.makeWithPoints(prevFaceOff.team2.points),
        }

        nextFaceOff'->FaceOffIntro->updateGame->Broadcaster.Sync->Broadcaster.sendEvent

        setTimeout(() => {
          nextFaceOff'->FaceOff->updateGame->Broadcaster.Sync->Broadcaster.sendEvent
        }, 4000)->ignore
      }
    | (_, FastMoney(nextFastMoney)) => {
        FastMoneyIntro->updateGame->Broadcaster.Sync->Broadcaster.sendEvent

        setTimeout(() => {
          nextFastMoney->FastMoney->updateGame->Broadcaster.Sync->Broadcaster.sendEvent
        }, 4000)->ignore
      }
    | _ => panic("not implemented")
    }

    let _ = updateGameIndex(gameIndex + 1)
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

  <>
    <div>
      {React.string(`Spiel ${gameIndex->Int.toString} von ${games->Array.length->Int.toString}`)}
    </div>
    {switch game {
    | Intro => <IntroController next />
    | FaceOffIntro(_) => <FaceOffIntroController />
    | FaceOff(faceOff) => <FaceOffController game=faceOff updateGame=updateFaceOff next />
    | FastMoneyIntro => <FastMoneyIntroController />
    | FastMoney(fastMoney) => <FastMoneyController game=fastMoney updateGame=updateFastMoney />
    }}
  </>
}
