defmodule GraffitiRemoval do
  @moduledoc """
  Documentation for GraffitiRemovalRequestFetcher.
  """

  @doc """
    dialyxir:   mix dialyzer
    credo:   mix credo [--strict, list],  
    httpoison: 
    jason
    benchee

    A. executable
    1. Http client to fetch data - TBD
    2. Streams to process - NA
    3. CLI to chomp from user - DONE
    4. Recusion, matching (guards for multi-head fns) - WIP
    5. Structs, @specs, exceptions, behaviors - WIP
    6. Tests - WIP
        API response is json
        API response status code is 200
    7. Error handling
    8. Docs @docs
    9. Benchmark

    B app: GenServer with Supervisor link to store past data

  """


  def ward_aldermen_data do
    %{1 => "Daniel La Spata", 
      2 => "Brian Hopkins", 
      3 => "Pat Dowell", 
      4 => "Sophia King", 
      5 => "Leslie Hairston", 
      6 => "Roderick Sawyer", 
      7 => "Gregory Mitchell", 
      8 => "Michelle Harris", 
      9 => "Anthony Beale", 
      10 => "Susan Sadlowski Garza", 
      11 => "Patrick Thompson", 
      12 => "George A. Cardenas", 
      13 => "Marty Quinn", 
      14 => "Ed Burke", 
      15 => "Raymond Lopez", 
      16 => "Stephanie D. Coleman", 
      17 => "David Moore", 
      18 => "Derrick Curtis", 
      19 => "Matthew O’Shea", 
      20 => "Jeanette B. Taylor", 
      21 => "Howard Brookins Jr.", 
      22 => "Michael D. Rodriguez", 
      23 => "Silvana Tabares", 
      24 => "Michael Scott Jr.", 
      25 => "Byron Sigcho Lopez", 
      26 => "Roberto Maldonado", 
      27 => "Walter Burnett, Jr.", 
      28 => "Jason Ervin", 
      29 => "Chris Taliaferro", 
      30 => "Ariel E. Reboyras", 
      31 => "Felix Cardona, Jr.", 
      32 => "Scott Waguespack", 
      33 => "Rossana Rodriguez Sanchez", 
      34 => "Carrie Austin", 
      35 => "Carlos Ramirez-Rosa", 
      36 => "Gilbert Villegas", 
      37 => "Emma Mitts", 
      38 => "Nicholas Sposato", 
      39 => "Samantha Nugent", 
      40 => "Andre Vasquez, Jr.", 
      41 => "Anthony Napolitano", 
      42 => "Brendan Reilly", 
      43 => "Michele Smith", 
      44 => "Thomas M. Tunney", 
      45 => "James M. Gardiner", 
      46 => "James Cappleman", 
      47 => "Matthew J. Martin", 
      48 => "Harry Osterman", 
      49 => "Maria E. Hadden", 
      50 => "Debra Silverstein"
    }
  end

end
