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
      padding: 0 1.5rem;

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

  let list = css(`
    counter-set: list;

    list-style: none;
    margin: 0;
    padding: 0;

  `)

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
  <div className=Styles.container>
    <main>
      <ol className=Styles.list>
        {props.faceOff.question.answers
        ->Array.mapWithIndex((answer, i) => {
          let text = answer.revealed ? String.padEnd(answer.text, 31, "_") : String.repeat("_", 31)
          let pointsText = answer.revealed ? Int.toString(answer.count) : "--"

          <li key={Int.toString(i)} className=Styles.answer>
            <span> {React.string(text)} </span>
            <span> {React.string(pointsText)} </span>
          </li>
        })
        ->React.array}
      </ol>
      <div className=Styles.sum>
        {React.string(`Summe ${Int.toString(props.faceOff.points)}`)}
      </div>
    </main>
    <footer>
      <div> {props.faceOff.team1.points->Int.toString->React.string} </div>
      <div> {props.faceOff->FaceOff.getPointsWithMultiplicator->Int.toString->React.string} </div>
      <div> {props.faceOff.team2.points->Int.toString->React.string} </div>
    </footer>
  </div>
}
