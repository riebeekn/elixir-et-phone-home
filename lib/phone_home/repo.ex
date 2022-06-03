defmodule PhoneHome.Repo do
  use Ecto.Repo,
    otp_app: :phone_home,
    adapter: Ecto.Adapters.Postgres
end
