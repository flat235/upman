defmodule Upman.TableManager do
  use GenServer
  require Logger

  def init(_init_arg) do
    {:ok, %{}}
  end

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: TableManager)
  end

  def handle_call({:claim, name}, {pid, _} = _from, state) do
    if Map.has_key?(state, name) do
      Logger.info("#{__MODULE__}: returning saved ETS Table #{name}")
      table = state[name]
      give_table(table, name, Map.delete(state, name), pid)
    else
      Logger.info("#{__MODULE__}: returning new ETS Table named #{name}")
      give_table(:ets.new(name, [:named_table]), name, state, pid)
    end
  end

  defp give_table(table, name, new_state, pid) do
    :ets.setopts(table, {:heir, self(), name})
    :ets.give_away(table, pid, name)
    {:reply, {:ok, :claim, name}, new_state}
  end

  def handle_info({:"ETS-TRANSFER", table, _OldOwner, name}, state) do
    Logger.info("#{__MODULE__}: saving ETS Table named #{name}")
    {:noreply, Map.put(state, name, table)}
  end

  def claim_table(name) do
    GenServer.call(TableManager, {:claim, name})
  end
end
