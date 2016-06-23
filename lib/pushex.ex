defmodule Pushex do
  @moduledoc """
  Server for sending push notifications
  """
  use Application

  def start, do: Pushex.Supervisor.start_link

end
