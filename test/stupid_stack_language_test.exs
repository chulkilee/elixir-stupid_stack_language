defmodule StupidStackLanguageTest do
  use ExUnit.Case, async: true
  doctest StupidStackLanguage

  import ExUnit.CaptureIO

  test "Hello World" do
    assert capture_io(fn ->
             StupidStackLanguage.run("avdqvdmavvqmiqiiifvdlfbffiiiflblblfbqviiifbfiiifwdfwwiif")
           end) == "hello world"
  end

  test "Cat" do
    [
      {"X", "X"},
      {"abc", "a"}
    ]
    |> Enum.each(fn {input, expected} ->
      assert capture_io([input: input, capture_prompt: false], fn ->
               StupidStackLanguage.run("jf")
             end) == expected
    end)
  end

  test "Find the Factorial of a Number" do
    [
      {"1", "1"},
      {"2", "2"},
      {"3", "6"},
      {"4", "24"},
      {"5", "120"}
    ]
    |> Enum.each(fn {input, expected} ->
      assert capture_io([input: input, capture_prompt: false], fn ->
               StupidStackLanguage.run("hqdtmldubx")
             end) == expected
    end)
  end

  test "Calculator" do
    [
      {["2", "3", "0"], "5"},
      {["2", "3", "1"], "-1"},
      {["2", "3", "2"], "6"},
      {["8", "2", "3"], "4"}
    ]
    |> Enum.each(fn {input, expected} ->
      assert capture_io([input: Enum.join(input, "\n"), capture_prompt: false], fn ->
               StupidStackLanguage.run("hhhtdtdtblpxzubmxzublcxzubgxz")
             end) == expected
    end)
  end

  test "Print a box of any character" do
    [
      {"a",
       """
       aaa
       a a
       aaa\
       """},
      {"#",
       """
       ###
       # #
       ###\
       """}
    ]
    |> Enum.each(fn {input, expected} ->
      assert capture_io([input: input, capture_prompt: false], fn ->
               StupidStackLanguage.run("jfffavvflflqvvvviifblflflfff")
             end) == to_string(expected)
    end)
  end

  test "Ackermann function" do
    # from https://en.wikipedia.org/wiki/Ackermann_function
    [
      {0, 0, 1},
      {1, 0, 2},
      {2, 0, 3},
      {3, 0, 5},
      {0, 1, 2},
      {1, 1, 3},
      {2, 1, 5},
      {3, 1, 13},
      {0, 2, 3},
      {1, 2, 4},
      {2, 2, 7},
      {3, 2, 29},
      {0, 3, 4},
      {1, 3, 5},
      {2, 3, 9},
      {3, 3, 61}
    ]
    |> Enum.each(fn {m, n, expected} ->
      assert capture_io(
               [input: Enum.join([m, n], "\n"), capture_prompt: false],
               fn ->
                 StupidStackLanguage.run("hhaitbltlanlbailtbbbdaiaaubtbdlqdlavdqslobaublubirdubx")
               end
             ) == to_string(expected)
    end)
  end
end
