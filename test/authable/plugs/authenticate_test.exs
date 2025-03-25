defmodule Authable.Plug.AuthenticateTest do
  use ExUnit.Case
  use Plug.Test
  use Authable.{Rollbackable, ModelCase, ConnCase}
  import Authable.Factory
  alias Authable.Plug.Authenticate, as: AuthenticatePlug

  @default_opts [
    store: :cookie,
    key: "foobar",
    encryption_salt: "encrypted cookie salt",
    signing_salt: "signing salt",
    log: false
  ]

  @secret String.duplicate("abcdef0123456789", 8)
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))
  @opts AuthenticatePlug.init(scopes: ~w(read))

  setup do
    {:ok, conn: Authable.ConnTest.build_conn()}
  end

  defp sign_conn(conn) do
    conn.secret_key_base
    |> put_in(@secret)
    |> Plug.Session.call(@signing_opts)
    |> fetch_session
  end

  test "test authenticate! with valid credentials", %{conn: conn} do
    user = insert(:user)
    token = insert(:session_token, user_id: user.id, details: %{scope: "read"})
    conn = conn |> sign_conn |> put_session(:session_token, token.value)
    conn = AuthenticatePlug.call(conn, @opts)
    assert conn.assigns[:current_user] == user
  end

  test "test authenticate! with no credentials", %{conn: conn} do
    user = insert(:user)
    insert(:session_token, user_id: user.id)
    conn = conn |> sign_conn
    conn = AuthenticatePlug.call(conn, @opts)
    assert conn.state == :set
    assert conn.status == 403
    assert is_nil(conn.assigns[:current_user])
  end
end
