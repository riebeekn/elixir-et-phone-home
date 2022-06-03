defmodule PhoneHome do
  import Ecto.Query
  alias PhoneHome.Repo
  alias PhoneHome.Extraterrestrial

  # ===========================================================================
  def list_extraterrestrials do
    Extraterrestrial
    |> order_by(:name)
    |> Repo.all()
  end
end
