defmodule Authable.GrantTypes.Base do
  @moduledoc """
  Base module for OAuth2 grant types
  """

  @repo Application.compile_env!(:authable, :repo)
  @token_store Application.compile_env!(:authable, :token_store)
  @app Application.compile_env!(:authable, :app)
  @strategies Application.compile_env!(:authable, :strategies)

  def authorize(_params) do
    raise Authable.NotImplementedError, message: "Not implemented!"
  end

  def create_oauth2_tokens(user, grant_type, client_id, scope, redirect_uri \\ nil) do
    scopes_check(scope)

    token_params = %{
      user_id: user.id,
      details: %{
        grant_type: grant_type,
        client_id: client_id,
        scope: scope,
        redirect_uri: redirect_uri
      }
    }

    if @strategies[:refresh_token] do
      # create refresh_token
      refresh_token_changeset =
        @token_store.refresh_token_changeset(
          struct(@token_store),
          token_params
        )

      case @repo.insert(refresh_token_changeset) do
        {:ok, refresh_token} ->
          _token_params =
            token_params
            |> Map.merge(%{
              details: Map.put(token_params[:details], :refresh_token, refresh_token.value)
            })
      end
    end

    access_token_changeset =
      @token_store.access_token_changeset(
        struct(@token_store),
        token_params
      )

    case @repo.insert(access_token_changeset) do
      {:ok, access_token} -> access_token
    end
  end

  def app_authorized?(user_id, client_id) do
    @repo.get_by(@app, user_id: user_id, client_id: client_id)
  end

  defp scopes_check(scopes) do
    valid_scopes = Application.get_env(:authable, :scopes)
    desired_scopes = String.split(scopes, ",")
    Enum.each(desired_scopes, fn scope -> scope_check(valid_scopes, scope) end)
  end

  defp scope_check(valid_scopes, scope) do
    unless Enum.member?(valid_scopes, scope) do
      raise Authable.SuspiciousActivityError,
        message: "Scope: #{scope} is not supported!"
    end
  end
end
