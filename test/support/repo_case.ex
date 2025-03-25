defmodule Authable.RepoCase do
  @moduledoc """
  This module allows accessing defined repo models on init.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @repo Application.compile_env!(:authable, :repo)
      @resource_owner Application.compile_env!(:authable, :resource_owner)
      @token_store Application.compile_env!(:authable, :token_store)
      @client Application.compile_env!(:authable, :client)
      @app Application.compile_env!(:authable, :app)
    end
  end
end
