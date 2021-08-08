defmodule OnePiece.Commanded.CommandHandler do
  @doc """
  Convert the module into a `Commanded.Commands.Handler`.

  Use `Commanded.Aggregate.Multi` to generate multiple events from
  a single command. This can be useful when you want to emit multiple events
  that depend upon the aggregate state being updated.

  ## Usage

      defmodule MyCommandHandler do
        use OnePiece.Commanded.CommandHandler

        @impl Commanded.Commands.Handler
        def handle(account, command) do
          account
          |> Multi.new()
          |> Multi.execute(&withdraw_money(&1, command.amount))
          |> Multi.execute(&check_balance/1)
        end

        defp withdraw_money(account, amount) do
          # ...
        end

        defp check_balance(account, amount) do
          # ...
        end
      end
  """
  @spec __using__ :: any()
  defmacro __using__ do
    quote do
      @behaviour Commanded.Commands.Handler
      alias Commanded.Aggregate.Multi
    end
  end
end
