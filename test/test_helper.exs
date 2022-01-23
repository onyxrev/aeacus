ExUnit.start()

# Mix.Task.run "ecto.drop", ["--quiet", "-r", "Aeacus.Test.Repo"]
Mix.Task.run "ecto.create", ["--quiet", "-r", "Aeacus.Test.Repo"]
Mix.Task.run "ecto.migrate", ["--quiet", "-r", "Aeacus.Test.Repo"]

Aeacus.Test.Repo.start_link

defmodule Aeacus.Test.Seed do
  @moduledoc """
    Data is seeded here, and then the database is set to use transactions so the
    data persists for all tests, without allowing errant tests to affect one
    another. We therefore must check if the data exists in the database before
    inserting records.
  """

  use Aeacus.Test.Helper

  if Repo.get_by(MockResource, %{email: @email}) == nil do
    Repo.insert!(%MockResource{email: @email, hashed_password: @hashed_password})
  end
  if Repo.get_by(MockCustomResource, %{username: @username}) == nil do
    Repo.insert!(%MockCustomResource{username: @username, pass: @hashed_password})
  end
end

Ecto.Adapters.SQL.Sandbox.mode(Aeacus.Test.Repo, {:shared, self()})
