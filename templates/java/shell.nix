{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    jdk21
    maven
    gradle
    jdt-language-server
  ];
}

