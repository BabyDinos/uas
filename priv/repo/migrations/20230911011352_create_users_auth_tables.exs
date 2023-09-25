defmodule Uas.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext, null: false
      add :username, :string, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:users, [:email, :username])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

    create table(:users_profiles) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :bio, :binary, default: "Welcome to my profile!", null: false
      add :background_color, :string, default: "#FFFFFF"
      timestamps(updated_at: false)
    end

    create index(:users_profiles, [:user_id])

  end
end
