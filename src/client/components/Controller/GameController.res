type props = {
  config: Config.t,
  bcOptions: Broadcaster.options,
}

let make = props => {
  let (gameIndex, setGameIndex) = React.useState(_ => 0)
  let (display, setDisplay) = React.useState(_ => DisplayState.Intro(props.config.name))

  let bcSender = React.useRef(Obj.magic())
  let broadcast = React.useRef(Obj.magic())

  React.useEffect0(() => {
    bcSender.current = Broadcaster.Sender.make(props.bcOptions)
    broadcast.current = Broadcaster.Sender.sendEvent(bcSender.current, _)

    None
  })

  React.useEffect1(() => {
    broadcast.current(UpdateDisplayAnimated(display))

    None
  }, [display])

  let next = (prevGame: option<Game.t>) => {
    let nextGame = props.config.games[gameIndex]

    if Option.isSome(nextGame) {
      setGameIndex(_ => gameIndex + 1)
    }

    switch (prevGame, nextGame) {
    | (Some(FaceOff(prevFaceOff)), Some(FaceOff(nextFaceOff))) => {
        let nextFaceOff' = {
          ...nextFaceOff,
          teamBlue: Team.makeWithPoints(prevFaceOff.teamBlue.points),
          teamRed: Team.makeWithPoints(prevFaceOff.teamRed.points),
        }

        setDisplay(_ => FaceOffIntro(nextFaceOff'.multiplicator))

        setTimeout(() => {
          setDisplay(_ => FaceOffGame(nextFaceOff'))
        }, 4000)->ignore
      }
    | (_, Some(FaceOff(nextFaceOff))) => {
        setDisplay(_ => FaceOffIntro(nextFaceOff.multiplicator))

        setTimeout(() => {
          setDisplay(_ => FaceOffGame(nextFaceOff))
        }, 4000)->ignore
      }
    | (_, Some(FastMoney(nextFastMoney))) => {
        setDisplay(_ => FastMoneyIntro(nextFastMoney.name))

        setTimeout(() => {
          setDisplay(_ => FastMoneyGame(nextFastMoney))
        }, 3000)->ignore
      }
    | (_, None) => setDisplay(_ => Outro)
    }
  }

  React.useEffect0(() => {
    broadcast.current(UpdateDisplayAnimated(display))

    None
  })

  <>
    <div>
      {React.string(
        `Spiel ${gameIndex->Int.toString} von ${props.config.games->Array.length->Int.toString}`,
      )}
    </div>
    {switch display {
    | Blank => React.null
    | Intro(_) => <IntroController next={() => next(None)} />
    | FaceOffIntro(_) => <FaceOffIntroController />
    | FaceOffGame(faceOff) =>
      <FaceOffController
        bcSender=bcSender.current game=faceOff next={f => next(Some(FaceOff(f)))}
      />
    | FastMoneyIntro(_) => <FastMoneyIntroController />
    | FastMoneyGame(fastMoney) =>
      <FastMoneyController bcSender=bcSender.current game=fastMoney next={() => next(None)} />
    | Outro => <OutroController />
    }}
  </>
}
