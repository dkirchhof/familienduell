module Styles = {
  open Emotion

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
  /* let (game, setGame) = React.useState(_ => Game.make()) */

  /* let onBuzzer = team => { */
  /*   /1* setGame(_ => Game.buzzer(game, team)) *1/ */
    
  /* } */

  /* switch game.round { */
  /* | Round1(round) => */
  /*   <> */
  /*     <div className=Styles.display> */
  /*       <FaceOffDisplay round team1=game.team1 team2=game.team2 /> */
  /*     </div> */
  /*     <Strikes /> */
  /*   </> */
  /* | _ => React.null */
  /* } */

  React.null
}
