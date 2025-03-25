defmodule Authable.Authentication.BearerTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoBase
  import Authable.Factory
  alias Authable.Authentication.Bearer, as: BearerAuthentication

  @access_token_value "access_token_1234"

  setup do
    user = insert(:user)
    insert(:access_token, %{value: @access_token_value, user: user})
    :ok
  end

  test "authorize with bearer authentication" do
    {:ok, authorized_user} =
      BearerAuthentication.authenticate(@access_token_value, [])

    refute is_nil(authorized_user)
  end

  test "authorize with bearer authentication using Bearer prefix" do
    {:ok, authorized_user} =
      BearerAuthentication.authenticate("Bearer #{@access_token_value}", [])

    refute is_nil(authorized_user)
  end

  test "authorize with bearer authentication from map parameters" do
    {:ok, authorized_user} =
      BearerAuthentication.authenticate(
        %{"access_token" => @access_token_value},
        []
      )

    refute is_nil(authorized_user)
  end
end
