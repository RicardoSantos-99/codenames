alias Codenames.Accounts.User
alias Codenames.Accounts.UserToken
alias Codenames.Accounts.UserNotifier
alias Codenames.Server.Manager
alias Codenames.Server.Server
alias Codenames.Games.Board
alias Codenames.Game
alias Codenames.Repo
alias Codenames.Words
alias Codenames.Games.GameSchema

email = "Jp9K9@example.com"

board = %Codenames.Games.Board.BoardSchema{
  starting_team: :red,
  blue_team: %Codenames.Games.Team.TeamSchema{
    words: ["Zumbi", "Rosa", "Bola", "Xícara", "Dado", "Urso", "Navio", "Elefante"],
    players: [],
    spymaster: nil
  },
  red_team: %Codenames.Games.Team.TeamSchema{
    words: ["Laranja", "Jogo", "Faca", "Ferro", "Janela", "Queijo", "Ninho", "Hospedagem", "Rato"],
    players: [],
    spymaster: nil
  },
  words: [
    %{color: :red, revealed: false, word: "Hospedagem"},
    %{color: :red, revealed: false, word: "Ninho"},
    %{color: :neutral, revealed: false, word: "Sorvete"},
    %{color: :red, revealed: false, word: "Queijo"},
    %{color: :black, revealed: false, word: "Pato"},
    %{color: :neutral, revealed: false, word: "Iglu"},
    %{color: :blue, revealed: false, word: "Navio"},
    %{color: :blue, revealed: false, word: "Dado"},
    %{color: :blue, revealed: false, word: "Xícara"},
    %{color: :red, revealed: false, word: "Ferro"},
    %{color: :blue, revealed: false, word: "Bola"},
    %{color: :blue, revealed: false, word: "Rosa"},
    %{color: :blue, revealed: false, word: "Zumbi"},
    %{color: :red, revealed: false, word: "Laranja"},
    %{color: :blue, revealed: false, word: "Elefante"},
    %{color: :red, revealed: false, word: "Faca"},
    %{color: :neutral, revealed: false, word: "Café"},
    %{color: :neutral, revealed: false, word: "Ilha"},
    %{color: :neutral, revealed: false, word: "Quintal"},
    %{color: :red, revealed: false, word: "Jogo"},
    %{color: :red, revealed: false, word: "Janela"},
    %{color: :red, revealed: false, word: "Rato"},
    %{color: :neutral, revealed: false, word: "Ornamento"},
    %{color: :neutral, revealed: false, word: "Jardim"},
    %{color: :blue, revealed: false, word: "Urso"}
  ]
}

game = %{
  room_id: "5608a55d-e8a9-4625-ad51-6aaf1d8a0242",
  board: %{
    starting_team: "blue",
    blue_team: %{
      words: [
        "Sapato",
        "Abóbora",
        "Dinossauro",
        "Xadrez",
        "Ovelha",
        "Bola",
        "Mamão",
        "Zumbi",
        "Elefante"
      ],
      players: [],
      spymaster: "user"
    },
    red_team: %{
      words: ["Ornamento", "Mamão", "Igreja", "Ketchup", "Lobo", "Dente", "Rosa", "Pássaro"],
      players: [],
      spymaster: "user3"
    },
    words: [
      %{color: "neutral", revealed: false, word: "Sapato"}
    ]
  },
  admin_id: "5ec4bcbb-18c4-4326-b799-cf74c10bc0f4",
  status: "finish",
  round: 0
}
