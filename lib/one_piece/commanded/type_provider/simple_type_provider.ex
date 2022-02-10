defmodule OnePiece.Commanded.TypeProvider.SimpleTypeProvider do
  @moduledoc """
  Defines a `Commanded.EventStore.TypeProvider` behavior using a simple key-value pair of an event name string to
  an Elixir struct.

  ## Example


      defmodule MyTypeProvider do
        use OnePiece.Commanded.TypeProvider.SimpleTypeProvider

        register_mapping("account_created", %AccountCreated{})
        register_mapping("account_closed", %AccountClosed{})
      end
  """

  defmacro __using__(_) do
    quote do
      import OnePiece.Commanded.TypeProvider.SimpleTypeProvider, only: [register_mapping: 2]

      #      @behaviour Commanded.EventStore.TypeProvider
      @before_compile OnePiece.Commanded.TypeProvider.SimpleTypeProvider

      Module.register_attribute(__MODULE__, :mapping, accumulate: true)
    end
  end

  defmacro register_mapping(name, struct) do
    quote do
      OnePiece.Commanded.TypeProvider.SimpleTypeProvider.register_mapping(
        __MODULE__,
        unquote(name),
        unquote(struct)
      )
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      OnePiece.Commanded.TypeProvider.SimpleTypeProvider.__add_to_struct_funcs__(__MODULE__)
      OnePiece.Commanded.TypeProvider.SimpleTypeProvider.__add_to_string_funcs__(__MODULE__)
      Module.delete_attribute(__MODULE__, :mapping)
    end
  end

  @doc false
  def __add_to_string_funcs__(mod) do
    funcs =
      mod
      |> Module.get_attribute(:mapping)
      |> Enum.map(&to_string_func/1)

    quote do
      def to_string(struct) do
        raise ArgumentError,
              ~s(%#{inspect(struct.__struct__)}{} is not registered in the #{inspect(__MODULE__)} simple type provider)
      end
    end
  end

  defp to_string_func({name, struct}) do
    quote do
      def to_string(unquote(struct)) do
        unquote(name)
      end
    end
  end

  @doc false
  def __add_to_struct_funcs__(mod) do
    funcs =
      mod
      |> Module.get_attribute(:mapping)
      |> Enum.map(&to_struct_func/1)

    quote do
      unquote(funcs)

      def to_struct(name) do
        raise ArgumentError,
              ~s("#{inspect(name)}" is not registered in the #{inspect(mod)} simple type provider)
      end
    end
  end

  defp to_struct_func({name, struct}) do
    quote do
      def to_struct(unquote(name)) do
        unquote(struct)
      end
    end
  end

  @doc false
  def register_mapping(mod, name, struct) do
    unless is_struct(struct) do
      raise ArgumentError, "expected struct, got #{inspect(struct)}"
    end

    case find_mapping_by_name(mod, name) do
      nil ->
        Module.put_attribute(mod, :mapping, {name, struct})

      {_, event_struct} ->
        raise ~s("#{name}" name already registered with event struct %#{inspect(event_struct.__struct__)}{})
    end
  end

  defp find_mapping_by_name(mod, name) do
    mod
    |> Module.get_attribute(:mapping)
    |> Enum.find(&is_mapping?(&1, name))
  end

  defp is_mapping?({current_name, _type}, name) do
    current_name == name
  end
end
