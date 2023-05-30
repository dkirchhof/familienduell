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

type props = {
  bcOptions: Broadcaster.options,
}

let make = (props: props) => {
  let (displayState, setDisplayState) = React.useState(_ => DisplayState.Blank)

  let updateDisplay = display => {
    setDisplayState(_ => display)
  }

  let updateDisplayAnimated = display => {
    startViewTransition(document, () => {
      setDisplayState(_ => display)
    })
  }

  React.useEffect0(() => {
    Emotion.injectGlobal(Styles.globalStyle)

    let bcReceiver = Broadcaster.Receiver.make(props.bcOptions)

    Broadcaster.Receiver.listen(bcReceiver, event => {
      switch event {
      | UpdateDisplay(displayState) => updateDisplay(displayState)
      | UpdateDisplayAnimated(displayState) => updateDisplayAnimated(displayState)
      | PlaySound(sound) => AudioPlayer.play(sound, None)
      | PlaySoundLimited(sound, time) => AudioPlayer.play(sound, Some(time))
      }
    })

    // Some(() => Broadcaster.Receiver.unlisten(bcReceiver))
    None
  })

  switch displayState {
  | Blank =>
    <>
      <Display />
      <StrikesOff />
    </>
  | Intro(name) =>
    <>
      <Display>
        <IntroDisplay name />
      </Display>
      <StrikesOff />
    </>
  | FaceOffIntro(multiplicator) =>
    <>
      <Display>
        <FaceOffIntroDisplay multiplicator />
      </Display>
      <StrikesOff />
    </>
  | FaceOffGame(faceOff) =>
    <>
      <Display>
        <FaceOffDisplay faceOff />
      </Display>
      <Strikes teamBlue=faceOff.teamBlue teamRed=faceOff.teamRed />
    </>
  | FastMoneyIntro(name) =>
    <>
      <Display>
        <FastMoneyIntroDisplay name />
      </Display>
      <StrikesOff />
    </>
  | FastMoneyGame(fastMoney) =>
    <>
      <Display>
        <FastMoneyDisplay fastMoney />
      </Display>
      <StrikesOff />
    </>
  | Outro =>
    <>
      <Display>
        <OutroDisplay />
      </Display>
      <StrikesOff />
    </>
  }
}
