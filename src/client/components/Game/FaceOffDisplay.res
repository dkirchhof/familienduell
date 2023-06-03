module Styles = {
  open Emotion

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
      padding: 0 1rem;

      display: grid;
      grid-template-columns: 4rem 1fr 4rem;

      color: ${Theme.Colors.get(#primary)};
      background: ${Theme.Colors.get(#secondary)};

      font-size: 1.5rem;

      > div {
        text-align: center;
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
    gap: 0.25rem;
  `)

  let sum = css(`
    text-align: right;
    white-space: pre;
  `)
}

type props = {faceOff: FaceOff.t}

let make = (props: props) => {
  <div className=Styles.container>
    <main>
      <ol className=Styles.list>
        {props.faceOff.question.answers
        ->Array.mapWithIndex((answer, i) => {
          let text = answer.revealed
            ? answer.text->String.slice(~start=0, ~end=31)->String.padEnd(31, "_")
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
      <div> {props.faceOff.teamBlue.points->Int.toString->React.string} </div>
      <div> {props.faceOff->FaceOff.getPointsWithMultiplicator->Int.toString->React.string} </div>
      <div> {props.faceOff.teamRed.points->Int.toString->React.string} </div>
    </footer>
    <audio src="/assets/sounds/revealText.ogg" autoPlay=true />
  </div>
}
