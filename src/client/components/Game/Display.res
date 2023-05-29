module Styles = {
  open Emotion

  let display = css(`
    position: relative;
    width: 25rem;
    height: 16rem;

    > * {
      height: 100%;
    }

    > img {
      width: 100%;
      object-fit: contain;
    }
  `)

  let shadow = css(`
    position: absolute;
    inset: 0;
    pointer-events: none;

    z-index: 100;

    box-shadow: inset 0 3px 10px 2px black;
  `)
}

type props = {children?: Jsx.element}

let make = props => {
  <div className=Styles.display>
    {props.children->Option.getWithDefault(React.null)}
    <div className=Styles.shadow />
  </div>
}
