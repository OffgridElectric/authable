defmodule Authable.Authentications.BearerTest do
  use ExUnit.Case
  use Authable.Rollbackable
  use Authable.RepoCase
  import Authable.Factory
  alias Authable.Authentications.Bearer, as: BearerAuthentication

  @access_token_value "access_token_1234"

  setup do
    create(:access_token, %{value: @access_token_value})
    :ok
  end

  test "authorize with bearer authentication" do
    authorized_user = BearerAuthentication.authenticate(@access_token_value)
    refute is_nil(authorized_user)
  end

  test "authorize with bearer authentication from map parameters" do
    authorized_user = BearerAuthentication.authenticate(%{"access_token" => @access_token_value})
    refute is_nil(authorized_user)
  end
end
