@send external startViewTransition: (Dom.document, unit => unit) => unit = "startViewTransition"

module Styles = {
  open Emotion

  let intro = css(`
    display: flex;
    align-items: center;
    justify-content: center;
  `)

  let container = css(
    `
    display: grid;
    grid-template-rows: 1fr 1.5rem;

    > main {
      padding: 1.5rem;

      display: grid;
      grid-template-rows: 1fr auto;
    }

    > footer {
      padding: 0.2rem 1rem;

      color: ${Theme.Colors.get(#primary)};
      background: ${Theme.Colors.get(#secondary)};

      > div {
        view-transition-name: footer;
        contain: paint;

        display: grid;
        grid-template-columns: 4rem 1fr 4rem;

        height: 100%;

        background: ${Theme.Colors.get(#secondary)};

        font-size: 1.3rem;
        line-height: 1;

        > div {
          text-align: center;
        }
      }
    }
  `,
  )

  let list = css(
    `
    counter-set: list;

    list-style: none;
    margin: 0;
    padding: 0;
    
    background: ${Theme.Colors.get(#primary)};
  `,
  )

  let answer = css(`
    ::before {
      content: counter(list) ".";
      counter-increment: list;
    }

    display: grid;
    grid-template-columns: auto 1fr auto;
  `)

  let sum = css(`
    text-align: right;
    white-space: pre;
  `)
}

type props = {faceOff: FaceOff.t}

let make = (props: props) => {
  let (showIntro, setShowIntro) = React.useState(_ => true)

  React.useEffect0(() => {
    let _ = setTimeout(() => {
      startViewTransition(
        document,
        () => {
          setShowIntro(_ => false)
        },
      )
    }, 3000)

    None
  })

  if showIntro {
    <div className=Styles.intro>
      <img src={`/${Int.toString((props.faceOff.multiplicator :> int))}.png`} />
      <audio src="/roundIntro.ogg" autoPlay=true />
    </div>
  } else {
    <div className=Styles.container>
      <main>
        <ol className=Styles.list>
          {props.faceOff.question.answers
          ->Array.mapWithIndex((answer, i) => {
            let text = answer.revealed
              ? String.padEnd(answer.text, 31, "_")
              : String.repeat("_", 31)
            let pointsText = answer.revealed ? Int.toString(answer.count) : "--"

            <li key={Int.toString(i)} className=Styles.answer>
              <span> {React.string(text)} </span>
              <span> {React.string(pointsText)} </span>
            </li>
          })
          ->React.array}
        </ol>
        <div className=Styles.sum>
          {React.string(`Summe ${props.faceOff.points->Int.toString->String.padStart(2, " ")}`)}
        </div>
      </main>
      <footer>
        <div>
          <div> {props.faceOff.team1.points->Int.toString->React.string} </div>
          <div>
            {props.faceOff->FaceOff.getPointsWithMultiplicator->Int.toString->React.string}
          </div>
          <div> {props.faceOff.team2.points->Int.toString->React.string} </div>
        </div>
      </footer>
    </div>
  }
}
