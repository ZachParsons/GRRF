defmodule Fetch do

  def main([]) do
    IO.puts "No input given. Retry."
  end

  def main(argv) do
    # IO.puts "hello"
    argv 
    |> List.first
    |> IO.inspect()
  end

end