# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Codenames.Repo.insert!(%Codenames.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Codenames.Repo
alias Codenames.Words.Word

words = [
  %Word{term: "Abacaxi"},
  %Word{term: "Abelha"},
  %Word{term: "Abóbora"},
  %Word{term: "Bola"},
  %Word{term: "Bolacha"},
  %Word{term: "Bolo"},
  %Word{term: "Cachorro"},
  %Word{term: "Cadeira"},
  %Word{term: "Café"},
  %Word{term: "Dado"},
  %Word{term: "Dente"},
  %Word{term: "Dinossauro"},
  %Word{term: "Elefante"},
  %Word{term: "Elevador"},
  %Word{term: "Escada"},
  %Word{term: "Faca"},
  %Word{term: "Fada"},
  %Word{term: "Ferro"},
  %Word{term: "Gato"},
  %Word{term: "Geladeira"},
  %Word{term: "Girafa"},
  %Word{term: "Helicóptero"},
  %Word{term: "Hipopótamo"},
  %Word{term: "Hospedagem"},
  %Word{term: "Igreja"},
  %Word{term: "Iglu"},
  %Word{term: "Ilha"},
  %Word{term: "Janela"},
  %Word{term: "Jardim"},
  %Word{term: "Jogo"},
  %Word{term: "Ketchup"},
  %Word{term: "Kiwi"},
  %Word{term: "Kung Fu"},
  %Word{term: "Laranja"},
  %Word{term: "Lápis"},
  %Word{term: "Lobo"},
  %Word{term: "Mala"},
  %Word{term: "Mamão"},
  %Word{term: "Mesa"},
  %Word{term: "Nariz"},
  %Word{term: "Navio"},
  %Word{term: "Ninho"},
  %Word{term: "Ovo"},
  %Word{term: "Ovelha"},
  %Word{term: "Ornamento"},
  %Word{term: "Pá"},
  %Word{term: "Pássaro"},
  %Word{term: "Pato"},
  %Word{term: "Queijo"},
  %Word{term: "Quintal"},
  %Word{term: "Quarto"},
  %Word{term: "Rato"},
  %Word{term: "Rádio"},
  %Word{term: "Rosa"},
  %Word{term: "Sapato"},
  %Word{term: "Sapo"},
  %Word{term: "Sorvete"},
  %Word{term: "Tatu"},
  %Word{term: "Tatuagem"},
  %Word{term: "Tênis"},
  %Word{term: "Uva"},
  %Word{term: "Umbigo"},
  %Word{term: "Urso"},
  %Word{term: "Vaca"},
  %Word{term: "Vassoura"},
  %Word{term: "Vela"},
  %Word{term: "Xícara"},
  %Word{term: "Xadrez"},
  %Word{term: "Xarope"},
  %Word{term: "Zebra"},
  %Word{term: "Zoológico"},
  %Word{term: "Zumbi"}
]

Enum.each(words, fn word -> Repo.insert!(word) end)
