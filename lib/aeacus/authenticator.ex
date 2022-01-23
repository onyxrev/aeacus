defmodule Aeacus.Authenticator do
  @moduledoc """
    Safely and easily authenticate identity/passwords from any schema
  """

  @doc """
    Authenticates a resource based on the map keys: :identity, :password.
    Optionally, all configuration may be passed on the fly to support
    authenticating different resources.

    ex.)
      Aeacus.Authenticator.authenticate %{identity: "test@example.com",
      password: "1234"}
  """
  @spec authenticate(Map.t, Map.t | none) :: {:ok, term} | {:error, String.t}
  def authenticate(%{identity: id, password: pass}, configuration \\ %{}) do
    config = Aeacus.config(configuration)
    load_resource(id, config)
    |> check_pass(pass, config)
  end

  @doc """
    Same as authenticate/1, except a pre-loaded resource is used

    ex.)
      Aeacus.Authenticator.authenticate resource, %{identity: "test@example.com",
      password: "1234"}
  """
  @spec authenticate_resource(Map.t, Map.t, Map.t | none) :: {:ok, term} | {:error, String.t}
  def authenticate_resource(resource, %{password: pass}, configuration \\ %{}) do
    config = Aeacus.config(configuration)
    resource
    |> check_pass(pass, config)
  end

  #
  # Private
  #

  # @doc """
  #   Loads a resource from the configured repo, by matching against the
  #   configured field (Defaults to :email).
  # """
  defp load_resource(id, %{repo: repo, model: model, identity_field: id_field}) do
    repo.get_by(model, [{id_field, id}])
  end

  # @doc """
  #   "Checks" a password even if the resource can't be found.
  #
  #   This helps prevent leaking valid identities in timing attacks.
  # """
  defp check_pass(nil, _, %{crypto: crypto, error_message: error}) do
    crypto.no_user_verify
    {:error, error}
  end

  # @doc """
  #   Checks the password against the resources password_field as defined in the
  #   configuration (Defaults to :hashed_password).
  # """
  defp check_pass(resource, password, %{password_field: pw_field, crypto: crypto, error_message: error}) do
    crypto.check_pass(resource, password, hash_key: pw_field)
  end
end
