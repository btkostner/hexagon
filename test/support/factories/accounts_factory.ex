defmodule Hexagon.AccountsFactory do
  @moduledoc """
  This module defines test helpers for creating entities in the
  `Hexagon.Accounts` context.
  """

  use ExMachina.Ecto, repo: Hexagon.Repo

  def email_factory(_attrs) do
    sequence(:email, &"email-#{&1}@example.com")
  end

  def password_factory(_attrs) do
    sequence(:password, &"AbC!123456789-#{&1}")
  end

  def user_factory do
    %Hexagon.Accounts.User{
      email: build(:email),
      password: "password",
      hashed_password: "$2a$12$JsRrZOrs2EeVucYkDUin5.GKwr9ppL4hDLj6ncDGLyFtJRUH.kRl.",
      confirmed_at: ~N[2000-01-01 23:00:00]
    }
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
