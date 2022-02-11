defmodule OnePiece.Commanded.TypeProvider.Event do
  @moduledoc false

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
end
