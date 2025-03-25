defmodule Authable.Factory do
  @moduledoc """
  Generates factories
  """

  import Authable.Config, only: [repo: 0]
  use Authable.RepoBase
  use ExMachina.Ecto, repo: repo()

  def user_factory do
    struct(@resource_owner,
      email: sequence(:email, &"foo-#{&1}@example.com"),
      password: Bcrypt.hash_pwd_salt("12345678")
    )
  end

  def client_factory do
    struct(@client,
      name: sequence(:name, &"client#{&1}"),
      secret: Base.url_encode64(:crypto.strong_rand_bytes(32), padding: false),
      redirect_uri: "https://example.com/oauth2-redirect-path",
      settings: %{
        name: "example",
        icon: "https://example.com/icon.png"
      }
    )
  end

  def session_token_factory do
    struct(@token_store,
      name: "session_token",
      value: sequence(:value, &"st#{&1}"),
      expires_at: :os.system_time(:seconds) + 3600,
      details: %{scope: "session,read,write"}
    )
  end

  def access_token_factory do
    struct(@token_store,
      name: "access_token",
      value: sequence(:value, &"at#{&1}"),
      expires_at: :os.system_time(:seconds) + 3600,
      details: %{
        scope: "read",
        grant_type: "authorization_code"
      }
    )
  end

  def refresh_token_factory do
    struct(@token_store,
      name: "refresh_token",
      value: sequence(:value, &"rt#{&1}"),
      expires_at: :os.system_time(:seconds) + 3600,
      details: %{
        grant_type: "authorization_code",
        scope: "read"
      }
    )
  end

  def authorization_code_factory do
    struct(@token_store,
      name: "authorization_code",
      value: sequence(:value, &"ac#{&1}"),
      expires_at: :os.system_time(:seconds) + 900,
      details: %{
        scope: "read",
        grant_type: "password"
      }
    )
  end

  def app_factory do
    struct(@app,
      scope: "read,write"
    )
  end
end
