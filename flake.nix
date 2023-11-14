{
  description = "Sam's CV";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in

    {
      devShell = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
          pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.pandoc
              pkgs.tectonic
            ];
            shellHook = ''
              pandoc README.md --pdf-engine='tectonic' -o sam_pointer.pdf
            '';
       });

    };
}
