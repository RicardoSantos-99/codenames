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
topic = "game_room:85462899-b43f-4c15-96a0-f7322b42cd8b"

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

game = %Codenames.Games.GameSchema{
  id: nil,
  board: %Codenames.Games.Board.BoardSchema{
    id: nil,
    starting_team: :blue,
    blue_team: %Codenames.Games.Team.TeamSchema{
      id: nil,
      words: ["Ovo", "Umbigo", "Bolacha", "Faca", "Abelha", "Rato", "Zebra", "Zumbi", "Café"],
      players: ["chrome"],
      spymaster: "mozila"
    },
    red_team: %Codenames.Games.Team.TeamSchema{
      id: nil,
      words: ["Quintal", "Rádio", "Igreja", "Vela", "Urso", "Uva", "Faca", "Ovelha"],
      players: ["anonimo1"],
      spymaster: "brave"
    },
    words: [
      %{color: :red, revealed: false, word: "Quintal"},
      %{color: :blue, revealed: false, word: "Café"},
      %{color: :blue, revealed: false, word: "Ovo"},
      %{color: :neutral, revealed: false, word: "Dinossauro"},
      %{color: :neutral, revealed: false, word: "Ornamento"},
      %{color: :blue, revealed: false, word: "Umbigo"},
      %{color: :red, revealed: false, word: "Uva"},
      %{color: :red, revealed: false, word: "Igreja"},
      %{color: :neutral, revealed: false, word: "Bolo"},
      %{color: :red, revealed: false, word: "Vela"},
      %{color: :neutral, revealed: false, word: "Sorvete"},
      %{color: :red, revealed: false, word: "Rádio"},
      %{color: :neutral, revealed: false, word: "Quarto"},
      %{color: :blue, revealed: false, word: "Faca"},
      %{color: :blue, revealed: false, word: "Bolacha"},
      %{color: :red, revealed: false, word: "Faca"},
      %{color: :red, revealed: false, word: "Urso"},
      %{color: :neutral, revealed: false, word: "Cachorro"},
      %{color: :blue, revealed: false, word: "Zebra"},
      %{color: :blue, revealed: false, word: "Zumbi"},
      %{color: :blue, revealed: false, word: "Rato"},
      %{color: :neutral, revealed: false, word: "Rosa"},
      %{color: :black, revealed: false, word: "Mala"},
      %{color: :blue, revealed: false, word: "Abelha"},
      %{color: :red, revealed: false, word: "Ovelha"}
    ]
  },
  round: 0,
  status: "started",
  players: [],
  admin_id: nil,
  admin: "brave",
  room_id: "game_room:85462899-b43f-4c15-96a0-f7322b42cd8b",
  inserted_at: nil,
  updated_at: nil
}
