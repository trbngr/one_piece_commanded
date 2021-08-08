defmodule OnePiece.Commanded.ValueObject do
  @doc """
  Converts the module into an `Ecto.Schema`, and derive from `Jason.Encoder`.

  ## Usage

      defmodule MyValueObject do
        use OnePiece.Commanded.ValueObject

        embedded_schema do
          # ...
        end
      end
  """
  @spec __using__(opts :: []) :: any()
  defmacro __using__(_opts \\ []) do
    quote do
      use Ecto.Schema
      @derive Jason.Encoder
      @primary_key false
    end
  end
end
