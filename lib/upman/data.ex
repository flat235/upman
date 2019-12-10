defmodule Upman.Data do
  use Upman.ManagedTable

  def handle_call(:servers, _from, state) do
    servers = :ets.tab2list(state) |> Enum.into(%{})
    {:reply, servers, state}
  end

  def handle_call({:server, name}, _from, state) do
    server = :ets.lookup(state, name) |> List.first() 
    if server == nil do
      {:reply, nil, state}
    else
      {:reply, server |> elem(1) |> Enum.into(%{}), state}
    end
  end

  def handle_call({:upsert, server, params}, _from, state) do
    :ets.delete(state, server)

    data =
      Map.merge(params, %{
        "last_report" => DateTime.utc_now(),
        "reboot_needed" => params["reboot_needed"] || false,
        "locked" => params["locked"] || []
      })

    # reset clearances
    if data["reboot_needed"] == false do
      Upman.Clearance.upsert(server, %{"reboot" => "false"})
    end

    if data["updates"] == nil or Enum.count(data["updates"]) == 0 do
      Upman.Clearance.upsert(server, %{"update" => "false"})
    end

    Logger.info(inspect(data))
    :ets.insert(state, {server, data})
    entry = :ets.lookup(state, server) |> Enum.into(%{})
    {:reply, entry, state}
  end

  def servers do
    GenServer.call(__MODULE__, :servers)
  end

  def server(name) do
    GenServer.call(__MODULE__, {:server, name})
  end

  def upsert(server, params) do
    GenServer.call(__MODULE__, {:upsert, server, params})
  end
end
