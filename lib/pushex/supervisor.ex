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
      worker(Pushex.Server, [:ok])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
