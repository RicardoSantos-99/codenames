defmodule Codenames.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Codenames.Accounts` context.
  """

  def random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode64()
    |> String.slice(0..(length - 1))
    |> String.replace(~r{[+/=_-]}, "a")
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_username, do: "user#{random_string(5)}"
  def valid_user_password, do: "PASSword@112.f2jfwioKLJ!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      username: valid_username(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Codenames.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
