defmodule Aeacus do
  @moduledoc """
    A simple, secure, and highly configurable Elixir identity [username |
    email | id | etc.]/password authentication module to use with Ecto.
  """

  @default_config %{
    crypto: Pbkdf2,
    identity_field: :email,
    password_field: :hashed_password,
    error_message: "Invalid identity or password."
  }

  defdelegate authenticate(params), to: Aeacus.Authenticator
  defdelegate authenticate(params, configuration), to: Aeacus.Authenticator
  defdelegate authenticate_resource(resource, password), to: Aeacus.Authenticator
  defdelegate authenticate_resource(resource, password, configuration), to: Aeacus.Authenticator

  @doc """
  Exposes the crypto module's hash_pwd_salt function. Used to salt and hash a password
  """
  def hash_pwd_salt(password), do: config(nil).crypto.hash_pwd_salt(password)

  @doc """
  Decides to use the override_config or application config.
  The result is merged with the default configuration options specified by Aeacus.
  """
  @spec config(Map.t | nil) :: Map.t
  def config(override_config) do
    configuration = if is_nil(override_config) || Enum.empty?(override_config) do
      Enum.into(Application.get_env(:aeacus, Aeacus), %{})
    else
      override_config
    end

    Map.merge(@default_config, configuration)
  end
end
