defmodule Authable.Utils.Crypt do
  @moduledoc """
  Crypt utilities
  """

  alias Comeonin.Bcrypt

  def match_password(password, crypted_password) do
    Bcrypt.verify_pass(password, crypted_password)
  end

  def salt_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  def generate_token do
    SecureRandom.urlsafe_base64()
  end
end
