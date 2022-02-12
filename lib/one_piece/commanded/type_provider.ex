defmodule OnePiece.Commanded.TypeProvider do
  alias OnePiece.Commanded.TypeProvider
  alias OnePiece.Commanded.TypeProvider.{Event, Import}

  defmodule Error do
    defexception [:message]
  end

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :events, accumulate: true)
      Module.register_attribute(__MODULE__, :providers, accumulate: true)

      @before_compile TypeProvider
      @after_compile TypeProvider

      import TypeProvider, only: :macros
    end
  end

  defmacro register(event_struct, string_identifier),
    do: Event.register(event_struct, string_identifier)

  defmacro import_provider(provider),
    do: Import.register(provider)

  defmacro __before_compile__(_env) do
    to_string = TypeProvider.generate_to_string()
    to_struct = TypeProvider.generate_to_struct()

    code =
      quote do
        def __events__, do: @events

        unquote(to_string)
        unquote(to_struct)
      end

    code
  end

  @doc false
  def generate_to_string do
    quote do
      funcs = Enum.map(@events, &Event.generate_to_string/1)
      Module.eval_quoted(__MODULE__, funcs)

      funcs = Enum.flat_map(@providers, &Import.to_string_functions/1)
      Module.eval_quoted(__MODULE__, funcs)

      def to_string(struct) do
        raise Error,
              ~s(%#{inspect(struct.__struct__)}{} is not registered in the #{inspect(__MODULE__)} type provider)
      end
    end
  end

  @doc false
  def generate_to_struct do
    quote do
      funcs = Enum.map(@events, &Event.generate_to_struct/1)
      Module.eval_quoted(__MODULE__, funcs)

      funcs = Enum.flat_map(@providers, &Import.to_struct_functions/1)
      Module.eval_quoted(__MODULE__, funcs)

      def to_struct(name) do
        raise Error,
              ~s("#{inspect(name)}" is not registered in the #{inspect(__MODULE__)} type provider)
      end
    end
  end

  defmacro __after_compile__(_env, _bytecode) do
    quote do
      Enum.each(@providers, &Import.validate/1)
      Enum.each(@events, &Event.validate_struct/1)
    end
  end

  def is_type_provider?(module) do
    case Code.ensure_compiled(module) do
      {:module, module} ->
        module.__info__(:functions)[:__events__] == 0

      _ ->
        false
    end
  end
end
