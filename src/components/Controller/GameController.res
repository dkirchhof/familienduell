type props = {config: Config.t}

let make = props => {
  let (gameIndex, updateGameIndex, _) = SimpleState.use(0)
  let (game, updateGame, setGame) = SimpleState.use(Game.Intro(props.config.name))

  let next = () => {
    let nextGame = props.config.games[gameIndex]->Option.getExn

    switch (game, nextGame) {
    | (Intro(_), FaceOff(faceOff)) => {
        faceOff->FaceOffIntro->updateGame->Broadcaster.Sync->Broadcaster.sendEvent

        setTimeout(() => {
          faceOff->FaceOff->updateGame->Broadcaster.Sync->Broadcaster.sendEvent
        }, 4000)->ignore
      }
    | (FaceOff(prevFaceOff), FaceOff(nextFaceOff)) => {
        let nextFaceOff' = {
          ...nextFaceOff,
          teamBlue: Team.makeWithPoints(prevFaceOff.teamBlue.points),
          teamRed: Team.makeWithPoints(prevFaceOff.teamRed.points),
        }

        nextFaceOff'->FaceOffIntro->updateGame->Broadcaster.Sync->Broadcaster.sendEvent

        setTimeout(() => {
          nextFaceOff'->FaceOff->updateGame->Broadcaster.Sync->Broadcaster.sendEvent
        }, 4000)->ignore
      }
    | (_, FastMoney(nextFastMoney)) => {
        FastMoneyIntro(props.config.name)->updateGame->Broadcaster.Sync->Broadcaster.sendEvent

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

  let updateTimer = (player, timer) => {
    setGame(game => {
      let updatedGame = switch (game, player) {
      | (FastMoney(fastMoney), FastMoney.Player1) =>
        FastMoney.updateTimer(fastMoney, Player1, timer)
      | (FastMoney(fastMoney), FastMoney.Player2) =>
        FastMoney.updateTimer(fastMoney, Player2, timer)
      | _ => panic("invalid state transition")
      }

      Broadcaster.UpdateTimer(updatedGame, FastMoney.Timer.getTime(timer))->Broadcaster.sendEvent

      FastMoney(updatedGame)
    })
  }

  <>
    <div>
      {React.string(`Spiel ${gameIndex->Int.toString} von ${props.config.games->Array.length->Int.toString}`)}
    </div>
    {switch game {
    | Intro(_) => <IntroController next />
    | FaceOffIntro(_) => <FaceOffIntroController />
    | FaceOff(faceOff) => <FaceOffController game=faceOff updateGame=updateFaceOff next />
    | FastMoneyIntro(_) => <FastMoneyIntroController />
    | FastMoney(fastMoney) => <FastMoneyController game=fastMoney updateGame=updateFastMoney updateTimer/>
    }}
  </>
}
