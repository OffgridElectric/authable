defmodule Authable.Rollbackable do
  @moduledoc """
  This module allows auto DB rollback on each test block execution.
  """

  use ExUnit.CaseTemplate
  import Authable.Config, only: [repo: 0]

  using do
    quote do
    end
  end

  setup tags do
    case Ecto.Adapters.SQL.Sandbox.checkout(repo()) do
      :ok -> true
      {:already, :owner} -> true
    end

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(repo(), {:shared, self()})
    end

    :ok
  end
end
