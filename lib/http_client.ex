defmodule HTTPClient do
  alias HTTPoison

  def get do
    # HTTPoison.get("http://httparrot.herokuapp.com/get")
    # HTTPoison.get("https://data.cityofchicago.org/resource/hec5-y4x5.json?ward=0")
    {:ok, response} = HTTPoison.get("https://www.chicago.gov/city/en/about/wards.html")
    
    # Floki.parse(response.body)
    # |> IO.inspect(limit: :infinity)
  end
end