defmodule Pushex.Sender do
  @moduledoc """
  Module responsible for actual sending of pushes to Apns and Gcm services.
  """
  require Logger

  def send(push) do
    case notification = Pushex.Parser.parse(push) do
      %Pigeon.APNS.Notification{} -> Logger.debug(inspect notification); Pigeon.APNS.push(notification)
      %Pigeon.GCM.Notification{}  -> Pigeon.GCM.push(notification)
      _                           -> false
    end
  end
end
