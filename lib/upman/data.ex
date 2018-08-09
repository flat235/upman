defmodule Upman.Data do
  use GenServer
  require Logger

  def init(_args) do
    {:ok, :ets.new(:upman, [:named_table])}
  end

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: UpdateCache)
  end

  def handle_call(:servers, _from, state) do
    servers = :ets.tab2list(:upman) |> Enum.into(%{})
    {:reply, servers, state}
  end

  def handle_call({:server, name}, _from, state) do
    server = :ets.lookup(:upman, name) |> List.first |> elem(1) |> Enum.into(%{})
    {:reply, server, state}
  end

  def handle_call({:upsert, server, params}, _from, state) do
    :ets.delete :upman, server
    data = Map.merge params, %{
      "last_report" => DateTime.utc_now(),
      "reboot_needed" => params["reboot_needed"] || false,
      "locked" => params["locked"] || []
    }
    # reset clearances
    if data["reboot_needed"] == false do
      Upman.Clearance.upsert(server, %{"reboot" => "false"})
    end
    if data["updates"] == nil or Enum.count(data["updates"]) == 0 do
      Upman.Clearance.upsert(server, %{"updates" => "false"})
    end
    Logger.info inspect(data)
    :ets.insert :upman, {server, data}
    entry = :ets.lookup(:upman, server) |> Enum.into(%{})
    {:reply, entry, state}
  end

  def servers do
    GenServer.call UpdateCache, :servers
  end

  def server(name) do
    GenServer.call UpdateCache, {:server, name}
  end

  def upsert(server, params) do
    GenServer.call UpdateCache, {:upsert, server, params}
  end

end
