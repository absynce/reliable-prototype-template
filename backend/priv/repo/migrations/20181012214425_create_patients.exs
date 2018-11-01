defmodule Backend.Repo.Migrations.CreatePatients do
  use Ecto.Migration

  def change do
    create table(:patients) do
      add :firstName, :string
      add :lastName, :string
      add :mrn, :string
      add :dateOfBirth, :date

      timestamps()
    end

  end
end
