#!/bin/bash

sudo nixos-rebuild switch --flake .

home-manager switch -b backup --flake .
