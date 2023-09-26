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

  def bio_changeset(user, attrs) do
    user
    |> cast(attrs, [:bio])
    |> validate_bio()
  end

  def validate_binary(changeset, field) do
    field_value = get_field(changeset, field)

    case is_binary(field_value) do
      true -> changeset
      false ->
        add_error(changeset, field, "must be a binary")
    end
  end

  def validate_bio(changeset) do
    changeset
    |> validate_required([:bio])
    |> validate_length(:bio, min: 0, max: 300, message: "Too long")
    |> validate_binary(:bio)
  end

end
