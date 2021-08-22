#!/usr/bin/env bats
load "helper"

function setup() {
  common_setup
}

function teardown() {
  common_teardown
}

@test "it works" {
  asdf_current="$(cat <<EOF
elixir          1.12.2-otp-24   /home/example/.tool-versions
erlang          24.0.5          /home/example/.tool-versions
java            openjdk-16.0.2  /home/example/.tool-versions
nodejs          16.7.0          /home/example/.tool-versions
python          3.9.6           /home/example/.tool-versions
ruby            3.0.2           /home/example/.tool-versions
EOF
)"

  config="$(cat > .update-asdf-tools <<EOF
[versions]
* =~ \d+\.\d+\.\d+
* !=~ -dev
* !=~ \-rc\.
* !=~ alpha
* !=~ beta
elixir =~ \-otp-24$
java =~ ^openjdk-
python =~ ^\d
python !=~ \db\d*$
python !=~ \drc
ruby =~ ^\d
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all elixir" "$(cat "${data_dir}/elixir.txt")"
  stub_asdf "list all erlang" "$(cat "${data_dir}/erlang.txt")"
  stub_asdf "list all java" "$(cat "${data_dir}/java.txt")"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all python" "$(cat "${data_dir}/python.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"

  run update-asdf-tools
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
elixir   1.12.2-otp-24    1.12.2-otp-24
erlang   24.0.5           24.0.5
java     openjdk-16.0.2   openjdk-16.0.2
nodejs   16.7.0           16.7.0
python   3.9.6            3.9.6
ruby     3.0.2            3.0.2

No updates available.
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all elixir
$asdf_mock list all erlang
$asdf_mock list all java
$asdf_mock list all nodejs
$asdf_mock list all python
$asdf_mock list all ruby
EOF
)"
}
