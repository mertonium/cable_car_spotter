# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cable_car_spotter,
  ecto_repos: [CableCarSpotter.Repo]

# Configures the endpoint
config :cable_car_spotter, CableCarSpotter.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4jc+/zjnHJqjcd5xGhQArlSBm4Z5U50d2HMZaBgxt731d05Tc+bMDGO8yUEvDSmc",
  render_errors: [view: CableCarSpotter.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CableCarSpotter.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :cable_car_spotter, CableCarSpotter.Gettext,
  locales: ~w(en es)

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :arc,
  storage: Arc.Storage.S3,
  bucket: {:system, "CCS_BUCKET_NAME"},
  virtual_host: true

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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
