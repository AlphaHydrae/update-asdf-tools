#!/usr/bin/env bats
load "helper"

function setup() {
  common_setup
}

function teardown() {
  common_teardown
}

@test "install specific versions of tools" {
  asdf_current="$(cat <<EOF
nodejs          ______          No version set. Run "asdf <global|shell|local> nodejs <version>"
ruby            ______          No version set. Run "asdf <global|shell|local> nodejs <version>"
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 13.12.0" "(mock nodejs install)"
  stub_asdf "global nodejs 13.12.0" ""
  stub_asdf "install ruby jruby-9.2.18.0" "(mock ruby install)"
  stub_asdf "global ruby jruby-9.2.18.0" ""

  config="$(cat > .update-asdf-tools <<EOF
[versions]
nodejs = 13.12.0
ruby = jruby-9.2.18.0
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   13.12.0   16.7.0 available
ruby     ______   jruby-9.2.18.0   rbx-5.0 available

Updates found: 2

asdf install nodejs 13.12.0
(mock nodejs install)
asdf global nodejs 13.12.0

asdf install ruby jruby-9.2.18.0
(mock ruby install)
asdf global ruby jruby-9.2.18.0
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 13.12.0
$asdf_mock global nodejs 13.12.0
$asdf_mock install ruby jruby-9.2.18.0
$asdf_mock global ruby jruby-9.2.18.0
EOF
)"
}

@test "the specified versions are installed and set as global when more recent versions are already set" {
  asdf_current="$(cat <<EOF
nodejs   16.7.0    /home/example/.tool-versions
ruby     rbx-5.0   /home/example/.tool-versions
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 13.12.0" "(mock nodejs install)"
  stub_asdf "global nodejs 13.12.0" ""
  stub_asdf "install ruby jruby-9.2.18.0" "(mock ruby install)"
  stub_asdf "global ruby jruby-9.2.18.0" ""

  config="$(cat > .update-asdf-tools <<EOF
[versions]
nodejs = 13.12.0
ruby = jruby-9.2.18.0
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   16.7.0    13.12.0   16.7.0 available
ruby     rbx-5.0   jruby-9.2.18.0   rbx-5.0 available

Updates found: 2

asdf install nodejs 13.12.0
(mock nodejs install)
asdf global nodejs 13.12.0

asdf install ruby jruby-9.2.18.0
(mock ruby install)
asdf global ruby jruby-9.2.18.0
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 13.12.0
$asdf_mock global nodejs 13.12.0
$asdf_mock install ruby jruby-9.2.18.0
$asdf_mock global ruby jruby-9.2.18.0
EOF
)"
}

@test "nothing is updated when the specified versions of tools are already installed" {
  asdf_current="$(cat <<EOF
nodejs   13.12.0          /home/example/.tool-versions
ruby     jruby-9.2.18.0   /home/example/.tool-versions
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"

  config="$(cat > .update-asdf-tools <<EOF
[versions]
nodejs = 13.12.0
ruby = jruby-9.2.18.0
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   13.12.0          13.12.0   16.7.0 available
ruby     jruby-9.2.18.0   jruby-9.2.18.0   rbx-5.0 available

No updates available.
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
EOF
)"
}
