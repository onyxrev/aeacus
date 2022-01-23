defmodule Aeacus.Test.Helper do
  @doc false
  defmacro __using__(_opts) do
    quote do
      alias Aeacus.Authenticator
      alias Aeacus.Test.Repo
      alias Aeacus.Test.MockResource
      alias Aeacus.Test.MockCustomResource
      import Aeacus.Test.Assertions

      @bad_identity "I Don't Exist!"
      @bad_password "open sesame"
      @email "test@example.com"
      @username "a"
      @password "1234"
      @hashed_password Pbkdf2.hash_pwd_salt(@password)
    end
  end
end
