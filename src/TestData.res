type answer = {text: string, count: int}
type question = {text: string, answers: array<answer>}

// replace ß with ss
let questions = [
  {
    text: "Nennen Sie eine Farbe",
    answers: [
      {text: "Blau", count: 35},
      {text: "Rot", count: 23},
      {text: "Grün", count: 20},
      {text: "Gelb", count: 6},
      {text: "Schwarz", count: 4},
      {text: "Türkis", count: 3},
      {text: "Braun", count: 2},
      {text: "Hier steht eine sehr lange Antwort", count: 1},
    ],
  },
  {
    text: "Nennen Sie ein Fortbewegungsmittel",
    answers: [
      {text: "Auto", count: 70},
      {text: "Zug", count: 12},
      {text: "Flugzeug", count: 8},
      {text: "Fahrrad", count: 7},
      {text: "Motorrad", count: 2},
      {text: "Kettcar", count: 1},
    ],
  },
  {
    text: "Nennen Sie eine Zahl",
    answers: [
      {text: "Achtzig", count: 80},
      {text: "Neun", count: 9},
      {text: "Eins", count: 4},
      {text: "Null", count: 3},
      {text: "Sieben", count: 2},
      {text: "Neunundsechzig", count: 1},
    ],
  },
  {
    text: "Nennen Sie ein Land",
    answers: [
      {text: "Deutschland", count: 70},
      {text: "Spanien", count: 12},
      {text: "Niederlande", count: 5},
      {text: "Österreich", count: 3},
      {text: "Italien", count: 2},
      {text: "Portugal", count: 1},
    ],
  },
  {
    text: "Nennen Sie eine Filmreihe",
    answers: [
      {text: "Star Wars", count: 70},
      {text: "Matrix", count: 12},
      {text: "Der Herr der Ringe", count: 5},
      {text: "Harry Potter", count: 3},
      {text: "Planet der Affen", count: 2},
      {text: "Der Pate", count: 1},
    ],
  },
]
