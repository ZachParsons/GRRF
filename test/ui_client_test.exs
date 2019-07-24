defmodule FakeIO do
  defdelegate puts(message), to: IO
  def gets("Which alderman?"), do: "Doe"
  def gets(value), do: raise ArgumentError, message: "invalid argument #{value}"
end

defmodule GraffitiRemoval.UIClientTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest GraffitiRemoval.UIClient
  alias GraffitiRemoval.UIClient


  test "main/1" do
    assert capture_io(fn ->
      UIClient.main(FakeIO)
    end) == "Welcome to The Graffiti Removal Requests Reporter."
  end

    # test "receive_input/0 with input" do
    #   assert UIClient.receive_input("Which alderman?", FakeIO) == "Doe"
    # end

  


end
