defmodule Bencodex do
  @moduledoc """
    Bencodex is a encoder/decoder for the bencode protocol.

    Bencode supports four types of objects

      * `string`     - Implemented as an ASCII encoded binary
      * `integer`    - Encoded in base 10 ASCII
      * `list`       - Ordered, heterogenious list
      * `dictionary` - String keys with heterogenious values in lexicographical order
  """

  @doc """
    Decode Bencode terms into Elixir terms

      Bencodex.decode("i1e")        # => 1
      Bencodex.decode("3:foo")      # => "foo"
      Bencodex.decode("li1e3:fooe") # => [1, "foo"]
      Bencodex.decode("d3:fooi1ee") # => %{"foo" => 1}
  """
  def decode(input) do
    Enum.at(Enum.reverse(decode(input, [])), 0)
  end

  @doc """
    Encode Elixir terms into Bencode terms

    The accepted types are integer, binary (string), list and map

      Bencodex.encode(1)             # => "i1e"
      Bencodex.encode("foo")         # => "3:foo"
      Bencodex.encode([1, "foo"])    # => "li1e3:fooe"
      Bencodex.encode(%{"foo" => 1}) # => "d3:fooi1ee"
  """
  def encode(output) do
    encode(output, "")
  end

  defp decode(<< "i", tail :: binary >>, acc) do
    { int, rest } = decode_integer(tail, [])
    acc = [int | acc]
    decode(rest, acc)
  end

  defp decode(<< "l", tail :: binary >>, acc) do
    { list, rest } = decode_list(tail, [])
    acc = [list | acc]
    decode(rest, acc)
  end

  defp decode(<< "d", tail :: binary >>, acc) do
    { map, rest } = decode_dictionary(tail, [])
    acc = [map | acc]
    decode(rest, acc)
  end

  defp decode("", acc), do: acc

  defp decode(remaining, acc) do
    { bin, rest } = decode_binary(remaining, [])
    acc = [bin | acc]
    decode(rest, acc)
  end

  defp decode_integer(<< "e", tail :: binary >>, acc) do
    { List.to_integer(Enum.reverse(acc)), tail }
  end

  defp decode_integer(<< i :: integer, tail :: binary >>, acc) do
    acc = [i | acc]
    decode_integer(tail, acc)
  end

  defp decode_list(<< "e", tail :: binary >>, acc), do: { Enum.reverse(acc), tail }

  defp decode_list(items, acc) do
    { item, rest } = decode_with_rest(items)
    acc = [item | acc]
    decode_list(rest, acc)
  end

  defp decode_binary(<< ":", tail :: binary >>, acc) do
    length = List.to_integer(Enum.reverse(acc))
    << bin :: size(length)-binary, rest :: binary >> = tail
    { bin, rest }
  end

  defp decode_binary(<< i :: integer, tail :: binary >>, acc) do
    acc = [i | acc]
    decode_binary(tail, acc)
  end

  defp decode_dictionary(<< "e", tail :: binary >>, acc) do
    result = Enum.reduce(acc, Map.new, fn({ key, val }, map) ->
      Map.put(map, key, val)
    end)
    { result, tail }
  end

  defp decode_dictionary(pairs, acc) do
    { key, val_with_rest } = decode_with_rest(pairs)
    { val, rest } = decode_with_rest(val_with_rest)
    acc = [{ key, val } | acc]
    decode_dictionary(rest, acc)
  end

  defp decode_with_rest(<< "i", tail :: binary >>), do: decode_integer(tail, [])
  defp decode_with_rest(<< "l", tail :: binary >>), do: decode_list(tail, [])
  defp decode_with_rest(<< "d", tail :: binary >>), do: decode_dictionary(tail, [])
  defp decode_with_rest(binary), do: decode_binary(binary, [])

  defp encode(i, acc) when is_integer(i), do: acc <> "i#{i}e"

  defp encode(b, acc) when is_binary(b), do: acc <> "#{byte_size(b)}:#{b}"

  defp encode(l, acc) when is_list(l) do
    "#{acc}l" <> Enum.reduce(l, "", fn(element, acc) -> acc <> encode(element, "") end) <> "e"
  end

  defp encode(m, acc) when is_map(m) do
    "#{acc}d" <> Enum.reduce(Map.keys(m), "", fn(k, acc) -> acc <> encode(k, "") <> encode(Map.get(m, k), "") end) <> "e"
  end
end
