import Config

config :authable, Authable.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "mustafaturan",
  password: "123456",
  database: "authable_dev",
  hostname: "localhost",
  pool_size: 10
