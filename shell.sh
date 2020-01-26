#!/usr/bin/env sh
#nix-build -E "with import <nixpkgs> {}; callPackage "./${1-default.nix}" {}" --show-trace
nix-shell -E "with import <nixpkgs> {}; callPackage "./${1-default.nix}" {}" --show-trace --run-env
