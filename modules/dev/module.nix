{ config, pkgs, lib, inputs, ... }:

{
  users.users.carmine = {
    packages = with pkgs; [
      jetbrains.idea-community-bin
      rstudio
      vscode
      vscode-extensions.jnoortheen.nix-ide
      vscode-extensions.llvm-vs-code-extensions.vscode-clangd
      vscode-extensions.redhat.vscode-yaml
      vscode-extensions.redhat.vscode-xml
      vscode-extensions.rust-lang.rust-analyzer
      vscode-extensions.tamasfe.even-better-toml
    ];
  };
}