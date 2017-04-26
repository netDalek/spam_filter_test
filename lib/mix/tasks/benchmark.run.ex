defmodule Mix.Tasks.Benchmark.Run do
  use Mix.Task

  def run(_) do
    :benchmark.run
  end
end
