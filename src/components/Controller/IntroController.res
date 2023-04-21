type props = {next: unit => unit}

let make = props => {
  <div>
    <div> {React.string("Intro")} </div>
    <button onClick={_ => props.next()}> {React.string("Start")} </button>
  </div>
}