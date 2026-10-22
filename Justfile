set shell := ["bash", "-euc"]
set positional-arguments

default:
    @just --list

setup:
    uv sync --locked

run *args:
    uv run --locked python graphicalMM1.py "$@"

pyglet:
    uv run --locked python pygletMM1.py

test:
    uv run --locked pytest

check: test
    uv run --locked python -m py_compile MM1Q.py graphicalMM1.py pygletMM1.py
    uv run --locked python graphicalMM1.py --help

update:
    devenv update
    uv lock --upgrade
    uv sync --locked
