defmodule Authable.ConfigTest do
  use ExUnit.Case
  alias Authable.Config

  test ".repo" do
    assert Authable.Repo == Config.repo()
  end

  test ".scopes" do
    assert ~w(read write session) == Config.scopes()
  end

  test ".app_scopes" do
    assert "read,write,session" == Config.app_scopes()
  end

  test ".grant_types" do
    grant_types = %{
      authorization_code: Authable.GrantType.AuthorizationCode,
      client_credentials: Authable.GrantType.ClientCredentials,
      password: Authable.GrantType.Password,
      refresh_token: Authable.GrantType.RefreshToken
    }

    assert grant_types == Config.grant_types()
  end

  test ".auth_strategies" do
    auth_strategies = %{
      headers: %{
        "authorization" => [
          {~r/Basic ([a-zA-Z\-_\+=]+)/, Authable.Authentication.Basic},
          {~r/Bearer ([a-zA-Z\-_\+=]+)/, Authable.Authentication.Bearer}
        ],
        "x-api-token" => [
          {~r/([a-zA-Z\-_\+=]+)/, Authable.Authentication.Bearer}
        ]
      },
      query_params: %{
        "access_token" => Authable.Authentication.Bearer
      },
      sessions: %{
        "session_token" => Authable.Authentication.Session
      }
    }

    assert auth_strategies == Config.auth_strategies()
  end

  test ".header_auth" do
    headers = %{
      "authorization" => [
        {~r/Basic ([a-zA-Z\-_\+=]+)/, Authable.Authentication.Basic},
        {~r/Bearer ([a-zA-Z\-_\+=]+)/, Authable.Authentication.Bearer}
      ],
      "x-api-token" => [
        {~r/([a-zA-Z\-_\+=]+)/, Authable.Authentication.Bearer}
      ]
    }

    assert headers == Config.header_auth()
  end

  test ".query_params_auth" do
    query_params = %{
      "access_token" => Authable.Authentication.Bearer
    }

    assert query_params == Config.query_params_auth()
  end

  test ".session_auth" do
    session_auth = %{
      "session_token" => Authable.Authentication.Session
    }

    assert session_auth == Config.session_auth()
  end

  test ".expires_in" do
    expires_in = %{
      access_token: 3600,
      refresh_token: 24 * 3600,
      authorization_code: 300,
      session_token: 30 * 24 * 3600
    }

    assert expires_in == Config.expires_in()
  end

  test ".renderer" do
    assert Authable.Renderer.RestApi == Config.renderer()
  end

  test ".app_authorization" do
    assert Authable.Stub.AppAuthorization == Config.app_authorization()
  end
end
