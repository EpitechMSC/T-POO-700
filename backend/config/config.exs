# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :time_manager,
  ecto_repos: [TimeManager.Repo],
  generators: [timestamp_type: :utc_datetime],
  pagination: [page_size: 10]

# Configures the endpoint
config :time_manager, TimeManagerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: TimeManagerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TimeManager.PubSub,
  live_view: [signing_salt: "fl8TKrb0"]

config :cors_plug,
  origin: ["http://localhost:5173"],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  headers: ["Authorization", "Content-Type"],
  max_age: 86400

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :time_manager, TimeManager.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :waffle,
  storage: Waffle.Storage.Local,
  # in order to have a different storage directory from url
  storage_dir_prefix: "priv/waffle/private",
  # add custom host to url
  asset_host: {:system, "ASSET_HOST"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
