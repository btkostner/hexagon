defmodule Hexagon.PackagesFactory do
  @moduledoc """
  This module defines test helpers for creating entities in the
  `Hexagon.Packages` context.
  """

  use ExMachina.Ecto, repo: Hexagon.Repo

  def package_factory do
    %Hexagon.Packages.Package{
      name: sequence(:package_name, &"test-package-#{&1}"),
      type: :hex,
      description: "a package for testing",
      external_doc_url: "https://example.com"
    }
  end

  def release_factory do
    %Hexagon.Packages.Release{
      version: sequence(:release_version, &"0.0.#{&1}"),
      size_in_bytes: 100,
      package: build(:package)
    }
  end
end
