{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.mkimage = pkgs.callPackage ./mkimage-rockchip.nix { };
    });
}
