defmodule CodenamesWeb.RedirectController do
  @moduledoc """
    This controller decides where to send users:
    - If they're logged in, it sends them to the rooms page.
    - If they're not logged in, it sends them to the login page.
  """

  use CodenamesWeb, :controller

  def index(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/rooms")
    else
      redirect(conn, to: ~p"/users/log_in")
    end
  end
end
