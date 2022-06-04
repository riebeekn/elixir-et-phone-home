defmodule PhoneHome.SpeakAndSpellWorker do
  use Oban.Worker, queue: :phone_calls, max_attempts: 5

  # ===========================================================================
  def perform(%Job{attempt: attempt, args: %{"extraterrestrial_id" => extraterrestrial_id}}) do
    extraterrestrial = PhoneHome.get_extraterrestrial!(extraterrestrial_id)

    phone_home()
    |> case do
      {:ok, :call_connected} ->
        process_phone_home_result(extraterrestrial, :space_taxi_on_the_way, attempt)

        :ok

      {:error, :no_answer} ->
        error_status = error_status(attempt)
        process_phone_home_result(extraterrestrial, error_status, attempt)

        {:error, :no_answer}
    end
  end

  # ===========================================================================
  defp process_phone_home_result(extraterrestrial, status, attempt) do
    PhoneHome.update_extraterrestrial_communication_status!(
      extraterrestrial,
      status,
      attempt
    )
    |> PhoneHome.broadcast_extraterrestrial_update()
  end

  # ===========================================================================
  defp phone_home do
    1..5
    |> Enum.random()
    |> case do
      1 -> {:ok, :call_connected}
      _ -> {:error, :no_answer}
    end
  end

  # ===========================================================================
  defp error_status(5 = _attempt), do: :no_answer
  defp error_status(_attempt), do: :phoning_home
end
