#!/usr/bin/env -S just --justfile

alias l := list

[group('misc')]
list FP="":
    @gpg --list-keys --keyid-format long {{ FP }}
