defmodule OnePiece.Commanded.TypeProvider do
  alias OnePiece.Commanded.TypeProvider
  alias OnePiece.Commanded.TypeProvider.Event

  defmodule Error do
    defexception [:message]
  end

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :events, accumulate: true)

      @before_compile TypeProvider
      @after_compile TypeProvider

      import TypeProvider, only: :macros
    end
  end

  defmacro register(event_struct, string_identifier),
    do: Event.register(event_struct, string_identifier)

  defmacro __before_compile__(_env) do
    quote do
      to_struct_funcs = Enum.map(@events, &Event.generate_to_struct/1)

      Module.eval_quoted(__MODULE__, to_struct_funcs)

      def to_struct(name) do
        raise Error,
              ~s("#{inspect(name)}" is not registered in the #{inspect(__MODULE__)} type provider)
      end

      to_string_funcs = Enum.map(@events, &Event.generate_to_string/1)

      Module.eval_quoted(__MODULE__, to_string_funcs)

      def to_string(struct) do
        raise Error,
              ~s(%#{inspect(struct.__struct__)}{} is not registered in the #{inspect(__MODULE__)} type provider)
      end
    end
  end

  defmacro __after_compile__(_env, _bytecode) do
    quote do
      Enum.each(@events, &Event.validate_struct/1)
    end
  end
end
