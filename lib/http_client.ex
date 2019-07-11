defmodule HTTPClient do
  alias HTTPoison

  def get_by_ward_and_date(ward, date) do
    HTTPoison.get("https://data.cityofchicago.org/resource/hec5-y4x5.json?ward=#{ward}&creation_date=#{date}")
    |> IO.inspect(limit: :infinity)
  end
end