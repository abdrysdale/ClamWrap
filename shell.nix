{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.python38Packages.poetry
  ];
  shellHook=''
    poetry shell;
  '';
}
