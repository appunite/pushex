defmodule Pushex.Sender do
  @moduledoc """
  Module responsible for actual sending of pushes to Apns and Gcm services.
  """
  require Logger

  def send(push) do
    case notification = Pushex.Parser.parse(push) do
      %Pigeon.APNS.Notification{} -> Pigeon.APNS.push(notification, on_return("ios"))
      %Pigeon.GCM.Notification{}  -> Pigeon.GCM.push(notification, on_return("android"))
      _                           -> false
    end
  end

  def on_return(queue) do
    fn(x) ->
      case x do
        {:ok, notification} ->
          Logger.info("Successfully sent notification to #{queue}")
        {:error, :invalid_registration, notification} ->
          Logger.error("Invalid registration id sending #{notification}")
        {:error, :bad_device_token, notification} ->
          Logger.error("Bad device token sending #{notification}")
        {:error, reason, notification} ->
          Logger.error("Error because of: #{reason} sending #{notification}")        
      end
    end
  end

end
