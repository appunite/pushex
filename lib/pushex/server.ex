defmodule Pushex.Server do
  @moduledoc """
  Module implementing actual push server. It listens on redis list and sends pushes to Apns and GCM servers.
  """
  use GenServer
  require Logger

  def start_link(state, name: name) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  def init(queue) do
    Logger.info "Started listening on #{queue}"
    {:ok, redis} = Exredis.start_link
    send(self(), :start)

    {:ok, [queue: queue, redis: redis]}
  end

  def send(push) do
    GenServer.cast(self(), {:send, push})
  end

  def handle_info(:start, [queue: q, redis: r] = state) do
    case Exredis.Api.brpop(r, q, 1) do
      [_, push]   -> send(push)
      :undefined  -> :ok
    end

    send(self(), :start)

    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def handle_cast({:send, push}, state) do
    Pushex.Sender.send(push)
    {:noreply, state}
  end
end
