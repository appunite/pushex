defmodule Pushex.Parser do
  @moduledoc """
  Module for parsing push from pushr format JSON
  """
  use Pigeon.Notification

  def parse(push) do
    case Poison.parse(push) do
      {:ok, map} -> prepare_by_type(map)
      _          -> nil
    end
  end

  def prepare_by_type(map) do
    case map["type"] do
      "Pushr::MessageApns"  -> prepare_apns(map)
      "Pushr::MessageGcm"   -> prepare_gcm(map)
      _                     -> nil
    end
  end

  def prepare_apns(map) do
    initial_payload =
      %{"apns" => %{}}
      |> Map.merge(map["payload"])

    Pigeon.APNS.Notification.new(
      initial_payload, map["device"], map["app"]
    )
    |> put_alert(map["alert"])
    |> put_badge(map["badge"])
    |> put_content_available(map["content_available"])
    |> put_sound(map["sound"])
    |> put_category(map["category"])
  end

  def prepare_gcm(map) do
    Pigeon.GCM.Notification.new(
      map["data"],
      map["registration_ids"]
    )
  end

end
