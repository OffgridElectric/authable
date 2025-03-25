defmodule Authable.Models.Client do
  @moduledoc """
  Oauth2 client
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Authable.Utils.Crypt, as: CryptUtil

  @resource_owner Application.compile_env!(:authable, :resource_owner)
  @app Application.compile_env!(:authable, :app)
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "clients" do
    field :name, :string
    field :secret, :string
    field :redirect_uri, :string
    field :settings, :map
    belongs_to :user, @resource_owner
    has_many :apps, @app

    timestamps()
  end

  @required_fields ~w(name redirect_uri user_id)
  @optional_fields ~w(settings)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 4, max: 32)
    |> validate_format(:name, ~r/\A([a-zA-Z]+)([0-9a-zA-Z]*)\z/i)
    |> unique_constraint(:name)
    |> put_secret
  end

  defp put_secret(model_changeset) do
    put_change(model_changeset, :secret, CryptUtil.generate_token)
  end
end
