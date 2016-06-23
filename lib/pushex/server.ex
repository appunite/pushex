defmodule Pushex.Server do
  @moduledoc """
  Module implementing actual push server. It listens on redis list and sends pushes to Apns and GCM servers.
  """
  use GenServer
  require Logger

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    Logger.info "Started listening"
    send(self(), :start)

    {:ok, self()}
  end

  def send(push) do
    GenServer.cast(__MODULE__, {:send, push})
  end

  def handle_info(:start, pid) do
    case Exredis.Api.brpop("list", 1) do
      [_, push]   -> send(push)
      :undefined  -> :ok
    end

    send(self(), :start)

    {:noreply, pid}
  end

  def handle_cast({:send, push}, state) do
    Pushex.Sender.send(push)
    {:noreply, state}
  end
end
