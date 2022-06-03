defmodule PhoneHome.Extraterrestrial do
  use Ecto.Schema

  schema "extraterrestrials" do
    field :name, :string

    field :communication_status, Ecto.Enum,
      values: [:phoning_home, :space_taxi_on_the_way, :no_answer]

    field :communication_attempt, :integer, default: 0
    field :last_communication_attempt_timestamp, :utc_datetime
  end
end
