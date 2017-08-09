defmodule Solver do
  #first block is in {0, 0, 0}
  #next n blocks need to be in the same direction
  #test all solution recursively

  @moves %{
    up: &Solver.up/1,
    down: &Solver.down/1,
    left: &Solver.left/1,
    right: &Solver.right/1,
    forward: &Solver.forward/1,
    backward: &Solver.backward/1,
  }

  def example do
    [2, 1, 1, 2, 1, 2, 1, 1, 2, 2, 1, 1, 1, 2, 2, 2, 2]
  end

  def up({x, y, z}) do
    {x, y+1, z}
  end

  def down({x, y, z}) do
    {x, y-1, z}
  end

  def left({x, y, z}) do
    {x-1, y, z}
  end

  def right({x, y, z}) do
    {x+1, y, z}
  end

  def forward({x, y, z}) do
    {x, y, z+1}
  end

  def backward({x, y, z}) do
    {x, y, z-1}
  end

  def solve do
    solve({0, 0, 0}, example, [], [])
  end

  def solve(_current_position, [], space_taken, trace_so_far) do
    if conditions_met?(space_taken) do
      [trace_so_far]
    else
      []
    end
  end

  # returns list of solutions
  def solve(current_position, [in_row | rows_left], space_taken, trace_so_far) do
    if conditions_met?(space_taken) do
      @moves
      |> Map.keys()
      |> Enum.map(
      fn(direction) ->
        {new_postition, new_space_taken} = put_cubes(in_row, current_position, direction, space_taken)
        Enum.map(solve(new_postition, rows_left, new_space_taken, trace_so_far),
          fn(solution) ->
            [direction | solution]
          end)
      end)
      |> Enum.concat
    else
      []
    end
  end

  def put_cubes(0, currenct_position, _direction, space_taken) do
    {currenct_position, space_taken}
  end

  def put_cubes(n, current_position, direction, space_taken) do
    fun = @moves[direction]
    new_position = fun.(current_position)
    put_cubes(n-1, new_position, direction, [new_position | space_taken])
  end

  defp conditions_met?([]), do: true
  defp conditions_met?(space_taken) do
    are_cubes_in_different_places?(space_taken) and are_cubes_bound?(space_taken)
  end

  defp are_cubes_in_different_places?(space_taken) do
    length(space_taken) == length(Enum.uniq(space_taken))
  end

  defp are_cubes_bound?(space_taken) do
    xs = Enum.map(space_taken, fn({x,_,_}) -> x end)
    ys = Enum.map(space_taken, fn({_,y,_}) -> y end)
    zs = Enum.map(space_taken, fn({_,_,z}) -> z end)
    Enum.max(xs) - Enum.min(xs) < 3 and Enum.max(ys) - Enum.min(ys) < 3 and Enum.max(zs) - Enum.min(zs) < 3
  end
end
