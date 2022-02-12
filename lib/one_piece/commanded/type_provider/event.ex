defmodule OnePiece.Commanded.TypeProvider.Event do
  @moduledoc false

  alias OnePiece.Commanded.TypeProvider.Error

  def register(event_struct, string_identifier) do
    quote do
      @events {unquote(event_struct), unquote(string_identifier)}
    end
  end

  def generate_to_string({event_struct, string_identifier}) do
    quote do
      def to_string(unquote(event_struct)) do
        unquote(string_identifier)
      end
    end
  end

  def generate_to_struct({event_struct, string_identifier}) do
    quote do
      def to_struct(unquote(string_identifier)) do
        struct(unquote(event_struct))
      end
    end
  end

  def validate_struct({event_struct, _string_identifier}) do
    case Code.ensure_compiled(event_struct) do
      {:module, module} ->
        unless module.__info__(:functions)[:__struct__] do
          raise Error, message: "#{inspect(event_struct)} not a struct!"
        end

      _ ->
        raise Error, message: "#{inspect(event_struct)} not a struct!"
    end
  end
end
