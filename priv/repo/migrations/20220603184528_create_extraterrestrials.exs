defmodule PhoneHome.Repo.Migrations.CreateExtraterrestrials do
  use Ecto.Migration
  def change do
    create table(:extraterrestrials) do
      add :name, :string
      add :communication_status, :string
      add :communication_attempt, :integer
      add :last_communication_attempt_timestamp, :utc_datetime
    end
  end
end
