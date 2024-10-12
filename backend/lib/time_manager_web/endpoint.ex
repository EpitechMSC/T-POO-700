defmodule TimeManagerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :time_manager
  alias TimeManagerWeb.Router

  @session_options [
    store: :cookie,
    key: "_time_manager_key",
    signing_salt: "Iby4djDl",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :time_manager,
    gzip: false,
    only: TimeManagerWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :time_manager
  end

  plug CORSPlug, origin: ["*"]

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options

  plug TimeManagerWeb.Router

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
end
