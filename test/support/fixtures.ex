defmodule Aeacus.Test.MockResource do
  use Ecto.Schema
  schema "default_resource" do
    field :email, :string
    field :hashed_password, :string
  end
end

defmodule Aeacus.Test.MockCustomResource do
  use Ecto.Schema
  schema "custom_resource" do
    field :username, :string
    field :pass, :string
  end
end
