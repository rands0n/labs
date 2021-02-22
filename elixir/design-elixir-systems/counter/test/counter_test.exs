defmodule CounterTest do
  use ExUnit.Case
  doctest Counter

  test "inc/1 increments a value" do
    assert 2 == Counter.Core.inc(1)
  end

  describe "using counter server" do
    setup do
      {:ok, pid} = Counter.start()

      [pid: pid]
    end

    test "when initializing server", %{pid: pid} do
      assert Counter.state(pid) == 0
    end

    test "when ticking returns sum", %{pid: pid} do
      Counter.tick(pid)

      assert 1 == Counter.state(pid)
    end
  end
end
