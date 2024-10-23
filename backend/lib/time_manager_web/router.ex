defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :authenticate do
    plug TimeManagerWeb.Plugs.Authenticate
    plug TimeManagerWeb.Plugs.CSRFProtection
  end

  pipeline :manager_or_supervisor do
    plug TimeManagerWeb.Plugs.EnsureRole, ["Manager"]
  end

  pipeline :supervisor_only do
    plug TimeManagerWeb.Plugs.EnsureRole, ["Supervisor"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    post "/login", UserController, :login

    pipe_through :authenticate
    resources "/signal", SignalController, except: [:new, :delete]
    resources "/contrats", ContratController, except: [:new, :delete, :update, :create, :edit]
    # resources "/files", FileController

    get "/teams/:id/members", TeamController, :list_members
    resources "/teams", TeamController
    get "/users/me", UserController, :me
    get "/users/search", UserController, :search_by_email_or_username
    get "/workingtimes/stats/:id", WorkingTimeController, :stats
    get "/workingtimes/user/:id", WorkingTimeController, :search_by_userid
    get "/workingtimes/search/:id", WorkingTimeController, :search_by_userid_and_date_range
    get "/workingtimes/:user_id/weekly", WorkingTimeController, :weekly_stats
    get "/workingtimes/:user_id/monthly", WorkingTimeController, :monthly_stats
    get "/workingtimes/:user_id/yearly", WorkingTimeController, :yearly_stats

    resources "/workingtimes", WorkingTimeController, except: [:new, :edit]
    resources "/users", UserController, except: [:edit]
    resources "/clocks", ClockController, except: [:edit]

    pipe_through [:manager_or_supervisor]
    resources "/team_memberships", TeamMembershipController

    pipe_through [:supervisor_only]

    resources "/roles", RoleController, except: [:edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
