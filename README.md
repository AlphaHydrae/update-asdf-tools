# Update asdf tools

[![version](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/AlphaHydrae/update-asdf-tools/main/badge.json?version=0.0.0)](https://github.com/AlphaHydrae/scide/releases)
[![build](https://github.com/AlphaHydrae/update-asdf-tools/actions/workflows/build.yml/badge.svg)](https://github.com/AlphaHydrae/update-asdf-tools/actions/workflows/build.yml)
[![license](https://img.shields.io/static/v1?label=license&message=MIT&color=informational)](https://opensource.org/licenses/MIT)

A magic shell script to update all [asdf][asdf] tools to the latest version in
one command.

<!-- START doctoc -->
<!-- END doctoc -->

## Usage

Assuming you already have asdf installed with a few plugins, simply run the
command:

```bash
update-asdf-tools
```

## Requirements

* [Bash](https://www.gnu.org/software/bash/) 3+

## Installation

With [Homebrew](https://brew.sh):

```bash
brew tap alphahydrae/tools
brew install scide
```

With [cURL](https://curl.se):

```bash
PREFIX=/usr/local/bin \
  FROM=https://github.com/AlphaHydrae/update-asdf-tools/releases/download && \
  curl -sSL $FROM/v0.0.0/update-asdf-tools_v0.0.0.gz | gunzip -c > $PREFIX/update-asdf-tools && \
  chmod +x $PREFIX/update-asdf-tools
```

With [Wget](https://www.gnu.org/software/wget/):

```bash
PREFIX=/usr/local/bin \
  FROM=https://github.com/AlphaHydrae/update-asdf-tools/releases/download && \
  wget -qO- $FROM/v0.0.0/update-asdf-tools_v0.0.0.gz | gunzip -c > $PREFIX/update-asdf-tools && \
  chmod +x $PREFIX/update-asdf-tools
```

Or [download it](https://github.com/AlphaHydrae/update-asdf-tools/releases) yourself.

[asdf]: https://asdf-vm.com
