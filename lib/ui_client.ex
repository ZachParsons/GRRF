defmodule UIClient do

  def main(_args) do
    greeting()
    alderman = get_alderman()
    yyyy_mm = get_year_and_month()
    execute_command(alderman, yyyy_mm)
  end
  
  defp greeting(), do: IO.puts "Welcome to The Graffiti Removal Request Fetcher."
  
  defp get_alderman do
    IO.puts "Please enter the last name of the Alderman of the ward on which to report"
    receive_command()
  end
  
  defp get_year_and_month do
    IO.puts "Please enter year and month on which to report in this format: 2019-07"
    receive_command()
  end

  defp receive_command do
    IO.gets("\n> ")
    |> String.trim
    # |> String.downcase
  end

  defp execute_command(alderman, yyyy_mm)do
    IO.puts(alderman <> " " <> yyyy_mm)
  end



end