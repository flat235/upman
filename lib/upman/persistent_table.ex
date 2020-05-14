defmodule PersistentTable do
  require Logger

  defp path(name) do
    dir = Application.get_env(:upman, :persistdir, :error)
    if dir == :error do
      :error
    else
      if String.ends_with?(dir, "/") do
        {:ok, to_charlist(dir <> Atom.to_string(name))}
      else
        {:ok, to_charlist(dir <> "/" <> Atom.to_string(name))}
      end
    end
  end

  def write(table, name) do
    with {:ok, filename} <- path(name) do
      Logger.info("#{__MODULE__}: writing ETS Table to #{filename}")
      :ets.tab2file(table, filename)
    end
  end

  def read(name) do
    with {:ok, filename} <- path(name),
         {:ok, tbl} <- :ets.file2tab(filename) do
      Logger.info("#{__MODULE__}: returning persisted ETS Table from #{filename}")
      tbl
    else
      _ ->
        Logger.info("#{__MODULE__}: returning new ETS Table named #{name}")
        :ets.new(name, [:named_table])
    end
  end
end
