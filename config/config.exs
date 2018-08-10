# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :upman, UpmanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YcZKR5GO5BnuL0X3ZwzjgovikDU2mEHojuEgfV18xemz1H2qW2PBPKGQfjVf8gUG",
  render_errors: [view: UpmanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Upman.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :phoenix, :template_engines,
  pug: PhoenixExpug.Engine

config :exldap, :settings,
  server: "ldap.example.com",
  base: "dc=example,dc=com",
  port: 636,
  ssl: true,
  search_timeout: 5_000

config :exldap,
  group: "admins",
  userAttr: "uid",
  groupAttr: "cn",
  memberAttr: "memberUid"


import_config "#{Mix.env}.exs"
