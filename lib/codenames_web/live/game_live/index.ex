defmodule CodenamesWeb.GameLive.Index do
  use CodenamesWeb, :live_view

  import CodenamesWeb.Components.Card
  import CodenamesWeb.Components.Team
  alias CodenamesWeb.Presence

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    Phoenix.PubSub.subscribe(Codenames.PubSub, "game_room")

    Presence.track(
      self(),
      "game_room",
      user.email,
      user
    )

    CodenamesWeb.Endpoint.subscribe("game_room")
    # notify users that has a presence

    CodenamesWeb.Endpoint.broadcast("game_room", "presence_diff", %{})

    socket = assign(socket, :user_emails, fetch_current_emails())
    socket = assign(socket, :words, random_words_from_db())
    socket = assign(socket, :board, build_game_board())

    {:ok, socket}
  end

  defp fetch_current_emails() do
    CodenamesWeb.Presence.list("game_room")
    |> Enum.map(fn {email, _meta} -> email end)
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, reload_users(socket)}
  end

  def reload_users(socket) do
    users =
      Presence.list("game_room")
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)

    socket
    |> assign(:users, users)
  end

  defp random_words_from_db do
    all_words = words()

    Enum.take_random(all_words, 25)
  end

  defp build_game_board do
    all_words = random_words_from_db()

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
