defmodule Authable.Plug.UnauthorizedOnly do
  @moduledoc """
  Authable plug implementation to refute authenticated users to access resources.
  """

  import Plug.Conn
  import Authable.Config, only: [renderer: 0]
  alias Authable.Helper

  def init([]), do: false

  @doc """
  Plug function to refute authenticated users to access resources.

  ## Examples

      defmodule SomeModule.AppController do
        use SomeModule.Web, :controller
        plug Authable.Plug.UnauthorizedOnly when action in [:register]

        def register(conn, _params) do
          # only logged out users can access this action
        end
      end
  """
  def call(conn, _opts) do
    response_conn_with(conn, Helper.authorize_for_resource(conn, []))
  end

  defp response_conn_with(conn, nil), do: conn
  defp response_conn_with(conn, {:error, _, _}), do: conn

  defp response_conn_with(conn, _) do
    renderer = renderer()

    conn
    |> renderer.render(:bad_request, %{
      errors: %{details: "Only unauthorized access allowed!"}
    })
    |> halt
  end
end
