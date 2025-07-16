{ pkgs ? import <nixpkgs> {} }:
let
  stableBeam = pkgs.beam.packagesWith pkgs.erlang_26;
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    stableBeam.elixir
    stableBeam.erlang
    stableBeam.elixir-ls
    stableBeam.erlang-ls
    stableBeam.rebar3
  ];
  shellHook = ''
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
  '';
}

