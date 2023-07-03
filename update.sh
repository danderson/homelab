#!/usr/bin/env bash

set -x
nix flake update
./acrux/autogen.p.sh
