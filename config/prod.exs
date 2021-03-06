use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :cable_car_spotter, CableCarSpotterWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "cablecarspotter.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_BASE_KEY")

config :cable_car_spotter, CableCarSpotter.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: CableCarSpotter.PostgresTypes,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || 10),
  ssl: true

# Do not print debug messages in production
config :logger, level: :info

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

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :cable_car_spotter, CableCarSpotter.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :cable_car_spotter, CableCarSpotter.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :cable_car_spotter, CableCarSpotter.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
# COMMENTED OUT BECAUSE WE ARE USING HEROKU ENV VARS
#import_config "prod.secret.exs"
