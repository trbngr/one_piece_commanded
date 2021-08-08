defmodule OnePiece.Commanded.QueryHandler do
  @type t :: struct()

  @type error :: any()

  @doc """
  Handle the incoming `params` and return the result data.
  """
  @callback handle(params :: any()) :: {:ok, t()} | {:error, error()}

  @doc """
  Convert the module into a `OnePiece.Commanded.QueryHandler`.

  ## Usage

      defmodule MyQueryHandler do
        use OnePiece.Commanded.QueryHandler
        import Ecto.Query, only: [from: 2]

        @impl OnePiece.Commanded.QueryHandler
        def handle(params) do
          query = from u in User,
                    where: u.age > 18 or is_nil(params.email),
                    select: u

          {:ok, Repo.all(query)}
        end
      end
  """
  defmacro __using__ do
    quote do
      @behaviour OnePiece.Commanded.QueryHandler
    end
  end
end
