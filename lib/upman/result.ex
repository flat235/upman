defmodule Upman.Result do
  use Upman.ManagedTable

  def handle_call({:result, server}, _from, state) do
    result = :ets.lookup(state, server) |> List.first()
    if result == nil do
      {:reply, nil, state}
    else
      
      {:reply, result |> elem(1) |> Enum.into(%{}), state}
    end
  end

  def handle_call({:upsert, server, %{"log" => log} = _params}, _from, state) do
    :ets.delete(state, server)
    cleanlog = log
      |> to_string()
      |> String.replace("\r\n", "\n", [])
      |> String.replace("\r", "\n", [])
    timestamp = DateTime.utc_now()
    :ets.insert(state, {server, %{"log" => cleanlog, "timestamp" => timestamp}})
    {:reply, :ok, state}
  end

  def result(server) do
    GenServer.call(__MODULE__, {:result, server})
  end

  def upsert(server, params) do
    GenServer.call(__MODULE__, {:upsert, server, params})
  end
end
