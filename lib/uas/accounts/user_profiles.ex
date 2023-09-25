defmodule Uas.Accounts.UserProfiles do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_profiles" do
    field :bio, :binary
    field :background_color, :string
    belongs_to :user, Uas.Accounts.User, foreign_key: :user_id

    timestamps(updated_at: false)
  end

  def changeset(users_profiles, attrs) do
    users_profiles
    |> cast(attrs, [:user_id, :bio, :background_color])
  end
end
