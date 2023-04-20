@send external startViewTransition: (Dom.document, unit => unit) => unit = "startViewTransition"

module Styles = {
  let globalStyle = `
    :root {
      position: fixed;
      inset: 0;

      display: flex;
      align-items: center;
      justify-content: center;

      color: ${Theme.Colors.get(#secondary)};
      background: ${Theme.Colors.get(#primary)};

      font-family: Ericsson, monospace;
      font-size: 3rem;
      line-height: 1.15;
      text-transform: uppercase;
    }
  `
}

@react.component
let make = () => {
  let (game, setGame) = React.useState(_ => Game.Intro)

  let updateGame = game => {
    setGame(_ => game)
  }

  let updateGameAnimated = game => {
    startViewTransition(document, () => {
      setGame(_ => game)
    })
  }

  React.useEffect0(() => {
    Emotion.injectGlobal(Styles.globalStyle)

    Broadcaster.listen(event => {
      switch event {
      | Sync(game) => updateGameAnimated(game)
      | RevealBoth(game) =>
        updateGameAnimated(game)
        AudioPlayer.play(#revealBoth)
      | RevealAnswerText(game) =>
        updateGameAnimated(game)
        AudioPlayer.play(#revealText)
      | RevealAnswerCount(game, count) =>
        updateGame(game)

        if count > 0 {
          AudioPlayer.play(#revealCount)
        } else {
          AudioPlayer.play(#fail)
        }
      | Strike(game) =>
        updateGame(Game.FaceOff(game))
        AudioPlayer.play(#fail)
      | InvalidAnswer => AudioPlayer.play(#fail2)
      }
    })

    Some(Broadcaster.unlisten)
  })

  switch game {
  | Intro =>
    <>
      <Display>
        <IntroDisplay />
      </Display>
      <Strikes team1={Team.make()} team2={Team.make()} />
    </>
  | FaceOff(faceOff) =>
    <>
      <Display>
        <FaceOffDisplay faceOff />
      </Display>
      <Strikes team1=faceOff.team1 team2=faceOff.team2 />
    </>
  | FastMoney(fastMoney) =>
    <>
      <Display>
        <FastMoneyDisplay fastMoney />
      </Display>
      <Strikes team1={Team.make()} team2={Team.make()} />
    </>
  }
}
