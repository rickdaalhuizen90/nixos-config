{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    php83
    php83.packages.composer
    symfony-cli
    intelephense
    nodejs_20
    pnpm
    postgresql_16
  ];
}

