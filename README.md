# NixOS Configurations
This repository contains all of my NixOS modules, hosts, development shells, and other configurations. Feel free to take a look around, steal code, or use this as inspiration

## Host Installation
All hosts start out as a bootstrap, which contains the bare minimum packages to boot into NixOS, clone this repository, and rebuild as a specific host. Refer to the [bootstrap installation guide](bootstrap/installation-guide.md), which details disk partitioning, encryption, and writing a basic configuration.nix