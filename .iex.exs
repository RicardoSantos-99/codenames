alias Codenames.Accounts.User
alias Codenames.Accounts.UserToken
alias Codenames.Accounts.UserNotifier
alias Codenames.Game.Manager
alias Codenames.Game.Server
alias Codenames.Game.Match
alias Codenames.Repo
alias Codenames.Words

email = "Jp9K9@example.com"

board = %Codenames.Game.Board{
  starting_team: :red,
  blue_team: %Codenames.Game.Team{
    words: ["Zumbi", "Rosa", "Bola", "Xícara", "Dado", "Urso", "Navio", "Elefante"],
    players: [],
    spymaster: nil
  },
  red_team: %Codenames.Game.Team{
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
