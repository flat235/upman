defmodule Upman.ManagedTable do
  defmacro __using__(_) do
    quote([]) do
      use GenServer
      require Logger

      def init(_args) do
        Process.flag(:trap_exit, true)
        Logger.info("#{__MODULE__}: claiming ETS Table named #{__MODULE__}")
        Upman.TableManager.claim_table(__MODULE__)
        {:ok, nil}
      end

      def start_link(default) do
        GenServer.start_link(__MODULE__, default, name: __MODULE__)
      end

      def handle_info({:"ETS-TRANSFER", table, _OldOwner, name}, _state) do
        Logger.info("#{__MODULE__}: receiving ETS Table named #{name}")
        {:noreply, table}
      end

      def terminate(reason, state) do
        PersistentTable.write(state, __MODULE__)
      end
    end
  end
end
