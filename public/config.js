window.config = {
  name: "Linne muss sich noch einen Namen ausdenken",
  firstQuestionIndex: 0,
  gameConfigs: [
    // { type: "faceOff", answers: 8, multiplicator: 1 },
    // { type: "faceOff", answers: 7, multiplicator: 1 },
    // { type: "faceOff", answers: 6, multiplicator: 2 },
    // { type: "faceOff", answers: 5, multiplicator: 3 },
    { type: "fastMoney", questions: 5, timePlayer1: 20, timePlayer2: 25 },
  ],
  questions: [
    {
      text: "Nennen Sie eine Farbe",
      answers: [
        ["Blau", 35],
        ["Rot", 23],
        ["Grün", 20],
        ["Gelb", 6],
        ["Schwarz", 4],
        ["Türkis", 3],
        ["Braun", 2],
        ["Hier steht eine sehr lange Antwort", 1],
      ],
    },
    {
      text: "Nennen Sie ein Fortbewegungsmittel",
      answers: [
        ["Auto", 70],
        ["Zug", 12],
        ["Flugzeug", 8],
        ["Fahrrad", 7],
        ["Motorrad", 2],
        ["Kettcar", 1],
      ],
    },
    {
      text: "Nennen Sie eine Zahl",
      answers: [
        ["Achtzig", 80],
        ["Neun", 9],
        ["Eins", 4],
        ["Null", 3],
        ["Sieben", 2],
        ["Neunundsechzig", 1],
      ],
    },
    {
      text: "Nennen Sie ein Land",
      answers: [
        ["Deutschland", 70],
        ["Spanien", 12],
        ["Niederlande", 5],
        ["Österreich", 3],
        ["Italien", 2],
        ["Portugal", 1],
      ],
    },
    {
      text: "Nennen Sie eine Filmreihe",
      answers: [
        ["Star Wars", 70],
        ["Matrix", 12],
        ["Der Herr der Ringe", 5],
        ["Harry Potter", 3],
        ["Planet der Affen", 2],
        ["Der Pate", 1],
      ],
    },
  ],
}
