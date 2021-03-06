defmodule PhoneHome do
  import Ecto.Query
  alias PhoneHome.Repo
  alias PhoneHome.Extraterrestrial
  alias PhoneHome.SpeakAndSpellWorker

  alias Ecto.Changeset

  # ===========================================================================
  def list_extraterrestrials do
    Extraterrestrial
    |> order_by(:name)
    |> Repo.all()
  end

  # ===========================================================================
  def get_extraterrestrial!(id), do: Repo.get!(Extraterrestrial, id)

  # ===========================================================================
  def update_extraterrestrial_communication_status!(extraterrestrial, status, attempt \\ 0) do
    extraterrestrial
    |> Changeset.change(%{
      communication_status: status,
      communication_attempt: attempt,
      last_communication_attempt_timestamp: DateTime.utc_now() |> DateTime.truncate(:second)
    })
    |> Repo.update!()
  end

  # ===========================================================================
  def phone_home(extraterrestrials) do
    extraterrestrials
    |> Enum.each(fn extraterrestrial ->
      %{extraterrestrial_id: extraterrestrial.id}
      |> SpeakAndSpellWorker.new()
      |> Oban.insert()
    end)
  end

  @pub_sub_topic "extraterrestrial"
  # ===========================================================================
  def subscribe_to_extraterrestrial_updates() do
    Phoenix.PubSub.subscribe(PhoneHome.PubSub, @pub_sub_topic)
  end

  # ===========================================================================
  def broadcast_extraterrestrial_update(extraterrestrial) do
    Phoenix.PubSub.broadcast(
      PhoneHome.PubSub,
      @pub_sub_topic,
      {:extraterrestrial_updated, extraterrestrial}
    )
  end
end
