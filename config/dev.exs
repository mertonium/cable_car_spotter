use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :cable_car_spotter, CableCarSpotterWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]


# Watch static and templates for browser reloading.
config :cable_car_spotter, CableCarSpotterWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/cable_car_spotter_web/views/.*(ex)$},
      ~r{lib/cable_car_spotter_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :cable_car_spotter, CableCarSpotter.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: CableCarSpotter.PostgresTypes,
  username: "cablecarspotter",
  password: "c4bl3c4r",
  database: "cable_car_spotter_dev",
  hostname: "localhost",
  pool_size: 5

config :ex_aws,
  access_key_id: System.get_env("CCS_AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("CCS_AWS_SECRET_ACCESS_KEY"),
  region: "us-west-2",
  host: "s3-us-west-2.amazonaws.com",
  s3: [
    scheme: "https://",
    host: "s3-us-west-2.amazonaws.com",
    region: "us-west-2"
  ]

