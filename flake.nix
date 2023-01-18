{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      myapp = forAllSystems (system: pkgs.${system}.poetry2nix.mkPoetryApplication { projectDir = self; });
    in
    rec {
      packages = forAllSystems (system: {
        default =
          let
            spkgs = pkgs.${system};
            pypkgs = pkgs.${system}.python310Packages;
          in
         spkgs.stdenv.mkDerivation {
          name = "cmake-sanitizers";
          src = self;

         installPhase = ''
            cp -r $src $out
        '';
         };
      });

    };
}