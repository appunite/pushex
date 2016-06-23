defmodule Pushex.Sender do
  @moduledoc """
  Module responsible for actual sending of pushes to Apns and Gcm services.
  """
  require Logger

  def send(push) do
    Logger.info push
  end
end
