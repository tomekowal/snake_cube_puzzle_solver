defmodule SolverTest do
  use ExUnit.Case
  doctest Solver

  test "example is made of 3x3x3 cubes" do
    assert Enum.sum(Solver.example) == 3*3*3-1
  end

  test "up changes y" do
    assert Solver.up({0, 0, 0}) == {0, 1, 0}
  end

  test "puts cube in place" do
    assert Solver.put_cubes(1, {0,0,0}, :up, []) == {{0,1,0}, [{0,1,0}]}
  end

  test "solve" do
    solutions = Solver.solve()
    IO.inspect length(solutions)
    Enum.map(solutions, fn(solution) ->
      IO.inspect solution
    end)
  end
end
