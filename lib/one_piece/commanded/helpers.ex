defmodule OnePiece.Commanded.Helpers do
  @moduledoc """
  A Swiss Army Knife Helper Module.
  """

  @doc """
  Generates a UUID using the version 4 scheme, as described in [RFC 4122](https://datatracker.ietf.org/doc/html/rfc4122),
  with a hex format.
  """
  @spec generate_uuid :: String.t()
  def generate_uuid do
    Uniq.UUID.uuid4(:hex)
  end

  @doc """
  Transforms the given `source` map or struct into the `target` struct.
  """
  @spec struct_from(source :: struct(), target :: struct()) :: struct()
  def struct_from(%_{} = source, target) do
    struct(target, Map.from_struct(source))
  end

  @spec struct_from(attrs :: map(), target :: module()) :: struct()
  def struct_from(attrs, target) do
    struct(target, attrs)
  end
end
