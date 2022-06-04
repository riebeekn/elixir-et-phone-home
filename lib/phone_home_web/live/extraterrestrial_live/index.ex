defmodule PhoneHomeWeb.ExtraterrestrialLive.Index do
  use PhoneHomeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: PhoneHome.subscribe_to_extraterrestrial_updates()

    {:ok, assign(socket, :extraterrestrials, PhoneHome.list_extraterrestrials())}
  end

  # ===========================================================================
  @impl true
  def handle_event("phone_home", _params, socket) do
    socket.assigns.extraterrestrials
    |> Enum.filter(&(&1.communication_status == nil || &1.communication_status == :no_answer))
    |> PhoneHome.phone_home()

    {:noreply, socket}
  end

  # ===========================================================================
  @impl true
  def handle_info({:extraterrestrial_updated, updated_extraterrestrial}, socket) do
    updated_extraterrestrials =
      socket.assigns.extraterrestrials
      |> Enum.map(fn extraterrestrial ->
        if extraterrestrial.id == updated_extraterrestrial.id do
          updated_extraterrestrial
        else
          extraterrestrial
        end
      end)

    {:noreply, assign(socket, :extraterrestrials, updated_extraterrestrials)}
  end

  # ===========================================================================
  def communication_status_display_value(nil), do: "-"

  def communication_status_display_value(:space_taxi_on_the_way) do
    """
    <div class="row">
      <svg xmlns="http://www.w3.org/2000/svg" style="height:24px;color:green;margin-right:10px" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
      </svg>
      Space Taxi On The Way
    </div>
    """
    |> raw()
  end

  def communication_status_display_value(:no_answer) do
    """
    <div class="row">
      <svg xmlns="http://www.w3.org/2000/svg" style="height:24px;color:red;margin-right:10px" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
      No Answer
    </div>
    """
    |> raw()
  end

  def communication_status_display_value(:phoning_home) do
    """
    <div class="row">
      <svg style="height:24px;color:orange;margin-right:10px" class="spinner" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      Phoning Home
    </div>
    """
    |> raw()
  end

  # ===========================================================================
  def communication_attempt_display_value(0), do: "-"
  def communication_attempt_display_value(val), do: val

  # ===========================================================================
  def last_communication_attempt_timestamp_display_value(nil), do: "-"
  def last_communication_attempt_timestamp_display_value(val), do: val
end
