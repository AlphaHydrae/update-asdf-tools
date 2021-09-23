# Update asdf tools

[![version](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/AlphaHydrae/update-asdf-tools/main/badge.json?version=1.0.0)](https://github.com/AlphaHydrae/scide/releases)
[![build](https://github.com/AlphaHydrae/update-asdf-tools/actions/workflows/build.yml/badge.svg)](https://github.com/AlphaHydrae/update-asdf-tools/actions/workflows/build.yml)
[![license](https://img.shields.io/static/v1?label=license&message=MIT&color=informational)](https://opensource.org/licenses/MIT)

A magic shell script to update all [asdf][asdf] tools to the latest version in
one command.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Usage](#usage)
- [Configuration](#configuration)
- [Requirements](#requirements)
- [Installation](#installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Usage

Assuming you already have asdf installed with a few plugins, simply run the
command:

```bash
update-asdf-tools
```

## Configuration

`update-asdf-tools` is configured with the
`~/.config/update-asdf-tools/update-asdf-tools.conf` file:

You can filter which versions you want to consider for installation with regular
expressions:

```conf
# Filter which versions you want to consider for installation/update with
# regular expressions.
[versions]
# Only install versions that contain a digit.
* =~ \d+
# Do not install versions that match the word "dev".
* !=~ dev
# Install an OpenJDK variant of Java.
java =~ ^openjdk-
# Install Erlang OTP 24.x.
erlang =~ ^24
# Install Elixir for the correct version of OTP.
elixir =~ \-otp-24$
# Install a specific version of Ruby.
ruby = 2.7.2
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
  curl -sSL $FROM/v1.0.0/update-asdf-tools_v1.0.0.gz | gunzip -c > $PREFIX/update-asdf-tools && \
  chmod +x $PREFIX/update-asdf-tools
```

With [Wget](https://www.gnu.org/software/wget/):

```bash
PREFIX=/usr/local/bin \
  FROM=https://github.com/AlphaHydrae/update-asdf-tools/releases/download && \
  wget -qO- $FROM/v1.0.0/update-asdf-tools_v1.0.0.gz | gunzip -c > $PREFIX/update-asdf-tools && \
  chmod +x $PREFIX/update-asdf-tools
```

Or [download it](https://github.com/AlphaHydrae/update-asdf-tools/releases) yourself.

[asdf]: https://asdf-vm.com
