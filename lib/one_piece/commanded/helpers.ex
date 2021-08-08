defmodule OnePiece.Commanded.Helpers do
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
