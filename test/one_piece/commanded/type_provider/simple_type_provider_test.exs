defmodule OnePiece.Commanded.TypeProvider.SimpleTypeProviderTest do
  use ExUnit.Case, async: true
  alias OnePiece.Commanded.TypeProvider.SimpleTypeProvider

  defmodule SomethingHappened do
    defstruct [:id, :name]
  end

  defmodule SomethingElseHappened do
    defstruct [:id, :name]
  end

  defmodule GoodTypeProvider do
    use SimpleTypeProvider

    register_mapping("something_happened", %SomethingElseHappened{})
    register_mapping("something_else_happened", %SomethingHappened{})
  end

  test "reading a registered mapping using the event name" do
    IO.inspect(GoodTypeProvider.__info__(:functions))
    assert "something_happened" == GoodTypeProvider.to_string(%SomethingElseHappened{})
  end
end
