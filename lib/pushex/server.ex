defmodule Pushex.Server do
  @moduledoc """
  Module implementing actual push server. It listens on redis list and sends pushes to Apns and GCM servers.
  """
  use GenServer
  require Logger

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(queue) do
    Logger.info "Started listening"
    send(self(), :start)

    {:ok, queue}
  end

  def send(push) do
    GenServer.cast(__MODULE__, {:send, push})
  end

  def handle_info(:start, queue) do
    IO.puts queue
    case Exredis.Api.brpop(queue, 1) do
      [_, push]   -> send(push)
      :undefined  -> :ok
    end

    send(self(), :start)

    {:noreply, queue}
  end

  def handle_cast({:send, push}, state) do
    Pushex.Sender.send(push)
    {:noreply, state}
  end
end
