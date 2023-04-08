type t = {
  points: int,
  locked: bool,
  strikes: int,
}

type choice = Team1 | Team2

let make = () => {points: 0, locked: false, strikes: 0}
let makeWithPoints = points => {points, locked: false, strikes: 0}

let lock = team => {...team, locked: true}
let unlock = team => {...team, locked: false}
let addStrike = team => {...team, strikes: team.strikes + 1}
