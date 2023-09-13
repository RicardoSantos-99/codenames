defmodule CodenamesWeb.Router do
  use CodenamesWeb, :router

  import CodenamesWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {CodenamesWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  ## Authentication routes

  scope "/", CodenamesWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{CodenamesWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", CodenamesWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{CodenamesWeb.UserAuth, :ensure_authenticated}] do
      live "/rooms", RoomLive.Index, :index
      live "/rooms/new", RoomLive.Index, :new
      live "/rooms/:id/edit", RoomLive.Index, :edit

      live "/rooms/:id", RoomLive.Show, :show
      live "/rooms/:id/show/edit", RoomLive.Show, :edit
      live("/users/settings", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
    end
  end

  scope "/", CodenamesWeb do
    pipe_through([:browser])

    get("/", RedirectController, :index)
    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{CodenamesWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end

  if Application.compile_env(:codenames, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: CodenamesWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
