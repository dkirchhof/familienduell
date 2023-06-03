type props = {next: unit => unit}

let make = props => {
  <>
    <div> {React.string("Intro")} </div>
    <Button onClick={_ => props.next()}> {React.string("Start")} </Button>
  </>
}
