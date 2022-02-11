defmodule OnePiece.Commanded.TypeProvider.Import do
  @moduledoc false
  alias alias OnePiece.Commanded.TypeProvider
  alias OnePiece.Commanded.TypeProvider.{Error, Event, Import}

  def register(provider) do
    quote do
      @providers unquote(provider)
    end
  end

  def to_string_functions(provider) do
    provider
    |> Import.get_provider_events()
    |> Enum.map(&Event.generate_to_string/1)
  end

  def to_struct_functions(provider) do
    provider
    |> Import.get_provider_events()
    |> Enum.map(&Event.generate_to_struct/1)
  end

  def get_provider_events(provider) do
    if TypeProvider.is_type_provider?(provider),
      do: provider.__events__(),
      else: []
  end

  def validate(provider) do
    unless TypeProvider.is_type_provider?(provider) do
      raise Error, message: "#{inspect(provider)} not a #{inspect(TypeProvider)}!"
    end
  end
end
