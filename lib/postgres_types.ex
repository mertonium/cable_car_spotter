# Define types for postrgex - we're specifically using postgis
Postgrex.Types.define(CableCarSpotter.PostgresTypes,
                      [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
                      json: Poison)



