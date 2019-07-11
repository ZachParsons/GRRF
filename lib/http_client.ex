defmodule HTTPClient do
  
  alias HTTPoison

  def get do
    # HTTPoison.get("http://httparrot.herokuapp.com/get")
    HTTPoison.get("https://data.cityofchicago.org/resource/hec5-y4x5.json")
    |> IO.inspect()
  end
end