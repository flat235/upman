defmodule Upman.Clearance do
  use Upman.ManagedTable

  def handle_call({:clearance, name}, _from, state) do
    clearance =
      try do
        :ets.lookup(state, name) |> List.first() |> elem(1) |> Enum.into(%{})
      rescue
        _ -> %{}
      end

    {:reply, clearance, state}
  end

  def handle_call({:upsert, server, params}, _from, state) do
    old_clearance =
      try do
        :ets.lookup(state, server) |> List.first() |> elem(1) |> Enum.into(%{})
      rescue
        _ -> %{}
      end

    :ets.delete(state, server)
    data = Map.merge(old_clearance, params)
    Logger.info(inspect(data))
    :ets.insert(state, {server, data})
    entry = :ets.lookup(state, server) |> Enum.into(%{})
    {:reply, entry, state}
  end

  def clearance(name) do
    GenServer.call(__MODULE__, {:clearance, name})
  end

  def upsert(server, params) do
    GenServer.call(__MODULE__, {:upsert, server, params})
  end
end
