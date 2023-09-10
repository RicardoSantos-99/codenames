defmodule CodenamesWeb.GameLive.Index do
  use CodenamesWeb, :live_view

  import CodenamesWeb.Components.Card
  import CodenamesWeb.Components.Team

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Codenames.PubSub, "game_room")
    socket = assign(socket, :words, random_words_from_db())
    socket = assign(socket, :board, build_game_board())

    {:ok, socket}
  end

  @impl true
  def handle_info({:user_joined, user}, socket) do
    users = socket.assigns[:users] || []
    {:noreply, assign(socket, :users, [user | users])}
  end

  def handle_info({:user_left, user}, socket) do
    users = socket.assigns[:users] || []
    updated_users = List.delete(users, user)
    {:noreply, assign(socket, :users, updated_users)}
  end

  @impl true
  def handle_event("join", %{"user" => user}, socket) do
    Phoenix.PubSub.broadcast(Codenames.PubSub, "game_room", {:user_joined, user})
    {:noreply, socket}
  end

  def handle_event("leave", %{"user" => user}, socket) do
    Phoenix.PubSub.broadcast(Codenames.PubSub, "game_room", {:user_left, user})
    {:noreply, socket}
  end

  defp random_words_from_db do
    all_words = words()

    Enum.take_random(all_words, 25)
  end

  defp build_game_board do
    all_words = random_words_from_db()

    # Supondo que você tem um time que começa (azul ou vermelho)
    starting_team = Enum.random([:blue, :red])

    {blue_words, after_blue} =
      take_random_words(all_words, if(starting_team == :blue, do: 9, else: 8))

    {red_words, after_red} =
      take_random_words(after_blue, if(starting_team == :blue, do: 8, else: 9))

    {neutral_words, after_neutral} = take_random_words(after_red, 7)
    {black_word, _} = take_random_words(after_neutral, 1)

    %{
      starting_team: starting_team,
      blue: blue_words,
      red: red_words,
      neutral: neutral_words,
      black: List.first(black_word)
    }
  end

  defp take_random_words(words, count) do
    chosen_words = Enum.take_random(words, count)
    remaining_words = Enum.reject(words, fn word -> word in chosen_words end)
    {chosen_words, remaining_words}
  end

  def words(),
    do: [
      "palavra1",
      "palavra2",
      "palavra3",
      "palavra4",
      "palavra5",
      "palavra1",
      "palavra2",
      "palavra3",
      "palavra4",
      "palavra5",
      "palavra1",
      "palavra2",
      "palavra3",
      "palavra4",
      "palavra5",
      "palavra1",
      "palavra2",
      "palavra3",
      "palavra4",
      "palavra5",
      "palavra1",
      "palavra2",
      "palavra3",
      "palavra4",
      "palavra5"
    ]
end
