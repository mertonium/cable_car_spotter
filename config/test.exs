use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cable_car_spotter, CableCarSpotter.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cable_car_spotter, CableCarSpotter.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: CableCarSpotter.PostgresTypes,
  username: "postgres",
  password: "postgres",
  database: "cable_car_spotter_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

config :ex_aws,
  access_key_id: System.get_env("CCS_AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("CCS_AWS_SECRET_ACCESS_KEY"),
  region: "fakes3",
  s3: [
    scheme: "http://",
    host: "localhost",
    port: 4444
  ]


