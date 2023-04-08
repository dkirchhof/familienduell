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

type props = {
  /* gameType: Game.subGame, */
  team1: Team.t,
  team2: Team.t,
}

let make = props => {
  <div className=Styles.container>
    /* <main> */
    /*   <ol className=Styles.list> */
    /*     {props.round.question.answers */
    /*     ->Array.mapWithIndex((answer, i) => */
    /*       <li key={Int.toString(i)} className=Styles.answer> */
    /*         <span> {answer.text->String.padEnd(31, "_")->React.string} </span> */
    /*         <span> {React.string(Int.toString(answer.count))} </span> */
    /*       </li> */
    /*     ) */
    /*     ->React.array} */
    /*   </ol> */
    /*   <div className=Styles.sum> {React.string("SUMME 23")} </div> */
    /* </main> */
    /* <footer> */
    /*   <div> {props.team1.points->Int.toString->React.string} </div> */
    /*   <div> {React.string("23")} </div> */
    /*   <div> {props.team2.points->Int.toString->React.string} </div> */
    /* </footer> */
  </div>
}
