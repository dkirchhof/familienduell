@send external startViewTransition: (Dom.document, unit => unit) => unit = "startViewTransition"

module Styles = {
  open Emotion

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

  let display = css(`
    position: relative;
    width: 25rem;
    height: 14rem;

    ::after {
      content: "";

      position: absolute;
      inset: 0;
      pointer-events: none;

      box-shadow: inset 0 3px 10px 2px black;
    }

    > * {
      height: 100%;
    }
  `)
}

@react.component
let make = () => {
  let (game, setGame) = React.useState(_ => None)

  let updateGame = game => {
    setGame(_ => Some(game))
  }

  let updateGameAnimated = game => {
    startViewTransition(document, () => {
      setGame(_ => Some(game))
    })
  }

  React.useEffect0(() => {
    Emotion.injectGlobal(Styles.globalStyle)

    Broadcaster.listen(event => {
      switch event {
      | Sync(game) => updateGame(game)
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
      }
    })

    Some(Broadcaster.unlisten)
  })

  switch game {
  | Some(FaceOff(faceOff)) =>
    <>
      <div className=Styles.display>
        <FaceOffDisplay faceOff />
      </div>
      <Strikes team1=faceOff.team1 team2=faceOff.team2 />
    </>
  | Some(FastMoney(fastMoney)) =>
    <>
      <div className=Styles.display>
        <FastMoneyDisplay fastMoney />
      </div>
      <Strikes team1={Team.make()} team2={Team.make()} />
    </>
  | None => React.null
  }
}
