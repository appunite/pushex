defmodule Pushex do
  @moduledoc """
  Server for sending push notifications
  """
  use Application

  def start, do: Pushex.Supervisor.start_link

  def main(_arg) do
    start

    :timer.sleep(:infinity)
  end

end
