defmodule Pushex.Supervisor do
  @moduledoc """
  Push server supervisor
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :pushex)
  end

  def init(:ok) do
    children = [
      worker(Pushex.Server, [Application.get_env(:pushex, :ios_queue), [name: :ios_queue]], id: :ios_queue),
      worker(Pushex.Server, [Application.get_env(:pushex, :android_queue), [name: :android_queue]], id: :android_queue)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
