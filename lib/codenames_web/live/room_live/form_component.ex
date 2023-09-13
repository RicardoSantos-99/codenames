defmodule CodenamesWeb.RoomLive.FormComponent do
  use CodenamesWeb, :live_component

  alias Codenames.Rooms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage room records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="room-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:password]} type="text" label="Password" />
        <.input field={@form[:public]} type="checkbox" label="Public" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Room</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{room: room} = assigns, socket) do
    changeset = Rooms.change_room(room)

    {:ok, socket |> assign(assigns) |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"room" => room_params}, socket) do
    changeset =
      socket.assigns.room
      |> Rooms.change_room(room_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"room" => room_params}, socket) do
    save_room(socket, socket.assigns.action, room_params)
  end

  defp save_room(socket, :edit, room_params) do
    case Rooms.update_room(socket.assigns.room, room_params) do
      {:ok, room} ->
        notify_parent({:saved, room})

        {:noreply,
         socket
         |> put_flash(:info, "Room updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_room(socket, :new, room_params) do
    case Rooms.create_room(Map.put(room_params, "user_id", socket.assigns.user.id)) do
      {:ok, room} ->
        notify_parent({:saved, room})

        {:noreply,
         socket
         |> put_flash(:info, "Room created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end