defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    get "/users/search", UserController, :search_by_email_or_username
    get "/workingtimes/stats/:id", WorkingTimeController, :stats
    get "/workingtimes/user/:id", WorkingTimeController, :search_by_userid
    get "/workingtimes/search/:id", WorkingTimeController, :search_by_userid_and_date_range
    get "/working_times/:user_id/weekly", WorkingTimeController, :weekly_stats
    get "/working_times/:user_id/monthly", WorkingTimeController, :monthly_stats
    get "/working_times/:user_id/yearly", WorkingTimeController, :yearly_stats
    post "/api/clocks", ClockController, :create

    resources "/workingtimes", WorkingTimeController, except: [:new, :edit]
    resources "/users", UserController, except: [:edit]
    resources "/clocks", ClockController, except: [:edit]
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
