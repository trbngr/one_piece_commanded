defmodule OnePiece.Commanded.TypeProviderTest do
  use ExUnit.Case
  alias OnePiece.Commanded.TypeProvider

  defmodule SomethingHappened do
    defstruct [:id, :name]
  end

  defmodule SomethingElseHappened do
    defstruct [:id, :name]
  end

  defmodule ForeignEvent do
    defstruct [:id, :name]
  end

  defmodule TestTypeProvider do
    use TypeProvider

    register SomethingHappened, "something_happened"
    register SomethingElseHappened, "something_else_happened"
  end

  test "TestTypeProvider has expected functions" do
    functions = TestTypeProvider.__info__(:functions)
    assert 1 == functions[:to_string]
    assert 1 == functions[:to_struct]
  end

  test "ForeignEvent is not registered" do
    assert_raise(TypeProvider.Error, fn ->
      TestTypeProvider.to_string(ForeignEvent)
    end)

    assert_raise(TypeProvider.Error, fn ->
      TestTypeProvider.to_struct("ForeignEvent")
    end)
  end

  describe "SomethingHappened" do
    test "has to_string function" do
      assert "something_happened" == TestTypeProvider.to_string(SomethingHappened)
    end

    test "has to_struct function" do
      assert %SomethingHappened{} == TestTypeProvider.to_struct("something_happened")
    end
  end

  describe "SomethingElseHappened" do
    test "has to_string function" do
      assert "something_else_happened" == TestTypeProvider.to_string(SomethingElseHappened)
    end

    test "has to_struct function" do
      assert %SomethingElseHappened{} == TestTypeProvider.to_struct("something_else_happened")
    end
  end
end
