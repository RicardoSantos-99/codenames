defmodule CodenamesWeb.RoomLiveTest do
  use CodenamesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Codenames.RoomsFixtures
  import Codenames.AccountsFixtures

  @create_attrs %{
    password: "VAlid!Password123",
    name: "some name",
    public: true
  }
  @update_attrs %{
    password: "VAlid!Password123",
    name: "some updated name",
    public: false
  }
  @invalid_attrs %{password: nil, name: nil, public: false}

  defp create_room(_) do
    user = user_fixture()
    room = room_fixture(%{user_id: user.id}, preload: true)
    %{room: room, user: user}
  end

  describe "Index" do
    setup [:create_room]

    test "lists all rooms", %{conn: conn, room: room, user: user} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms")

      assert html =~ "Listing Rooms"
      assert html =~ room.name
    end

    test "saves new room", %{conn: conn, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms")

      assert index_live
             |> element("a", "New Room")
             |> render_click() =~ "New Room"

      assert_patch(index_live, ~p"/rooms/new")

      assert index_live
             |> form("#room-form", room: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#room-form", room: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/rooms")

      IO.puts("index_live: #{inspect(index_live)}")
      html = render(index_live)
      assert html =~ "Room created successfully"
      assert html =~ "some name"
    end

    test "updates room in listing", %{conn: conn, room: room, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms")

      assert index_live |> element("#rooms-#{room.id} a", "Edit") |> render_click() =~
               "Edit Room"

      assert_patch(index_live, ~p"/rooms/#{room}/edit")

      assert index_live
             |> form("#room-form", room: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#room-form", room: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/rooms")

      html = render(index_live)
      assert html =~ "Room updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes room in listing", %{conn: conn, room: room, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms")

      assert index_live |> element("#rooms-#{room.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#rooms-#{room.id}")
    end
  end

  describe "Show" do
    setup [:create_room]

    test "displays room", %{conn: conn, room: room, user: user} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms/#{room}")

      assert html =~ "Show Room"
      assert html =~ "Edit room"
    end

    test "updates room within modal", %{conn: conn, room: room, user: user} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/rooms/#{room}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Room"

      assert_patch(show_live, ~p"/rooms/#{room}/show/edit")

      assert show_live
             |> form("#room-form", room: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#room-form", room: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/rooms/#{room}")

      html = render(show_live)
      assert html =~ "Room updated successfully"
      assert html =~ "Edit room"
    end
  end
end
