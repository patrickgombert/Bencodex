defmodule Bencodex.Mixfile do
  use Mix.Project

  def project do
    [app: :bencodex,
     version: "0.1.0",
     elixir: "~> 0.15.0",
     description: "Encoder and decoder for the bencode format",
     package: package,
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    []
  end

  defp package do
    [contributors: ["Patrick Gombert"],
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/patrickgombert/bencodex"}]
  end
end
