defmodule BencodexTest do
  use ExUnit.Case, async: true

  test "decoding an integer" do
    integer = Bencodex.decode("i42e")
    assert integer == 42
  end

  test "decoding a binary" do
    binary = Bencodex.decode("11:hello world")
    assert binary == "hello world"
  end

  test "decoding a list with integers" do
    [integer1, integer2] = Bencodex.decode("li42ei43ee")
    assert integer1 == 42
    assert integer2 == 43
  end

  test "decoding a list with binaries" do
    [binary1, binary2] = Bencodex.decode("l11:hello world2:oke")
    assert binary1 == "hello world"
    assert binary2 == "ok"
  end

  test "decoding a dictionary" do
    map = Bencodex.decode("d2:hil2:ihi10eei2e5:helloe")
    assert Map.get(map, "hi") == ["ih", 10]
    assert Map.get(map, 2) == "hello"
  end

  test "encoding an integer" do
    assert Bencodex.encode(555) == "i555e"
  end

  test "encoding a binary" do
    assert Bencodex.encode("foo") == "3:foo"
  end

  test "encoding a list" do
    assert Bencodex.encode([1, "a"]) == "li1e1:ae"
  end

  test "encoing a map" do
    assert Bencodex.encode(%{"k" => "v"}) == "d1:k1:ve"
  end
end
