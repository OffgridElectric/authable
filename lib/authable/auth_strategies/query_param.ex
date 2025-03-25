defmodule Authable.AuthStrategy.QueryParam do
  @moduledoc """
  Authable Strategy implements behaviour Authable.Strategy to check query params
  based authencations to find resource owner.
  """

  import Authable.Config, only: [query_params_auth: 0]

  @behaviour Authable.AuthStrategy

  @doc """
  Finds resource owner using configured 'query params' keys. Returns nil if
  either no keys are configured or key value not found in the session.
  And, it returns `Authable.Model.User` on sucess,
  `{:error, Map, :http_status_code}` on fails.
  """
  def authenticate(conn, required_scopes \\ []) do
    query_params_auth = query_params_auth()

    unless is_nil(query_params_auth) do
      authenticate_via_query_params(
        query_params_auth,
        conn.query_params,
        required_scopes
      )
    end
  end

  defp authenticate_via_query_params(query_params_auth, params, required_scopes) do
    Enum.find_value(query_params_auth, fn {key, module} ->
      if Map.has_key?(params, key) do
        module.authenticate(params, required_scopes)
      end
    end)
  end
end
