defmodule PhoneHomeWeb.ExtraterrestrialLive.Index do
  use PhoneHomeWeb, :live_view

  # ===========================================================================
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :extraterrestrials, PhoneHome.list_extraterrestrials())}
  end

  # ===========================================================================
  def communication_status_display_value(nil), do: "-"
  def communication_status_display_value(val), do: val

  # ===========================================================================
  def communication_attempt_display_value(0), do: "-"
  def communication_attempt_display_value(val), do: val

  # ===========================================================================
  def last_communication_attempt_timestamp_display_value(nil), do: "-"
  def last_communication_attempt_timestamp_display_value(val), do: val
end
