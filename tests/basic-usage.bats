#!/usr/bin/env bats
load "helper"

function setup() {
  common_setup
}

function teardown() {
  common_teardown
}

@test "install the latest available versions of tools" {
  asdf_current="$(cat <<EOF
Name            Version         Source           Installed
nodejs          ______          ______
ruby            ______          ______
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "--version" "asdf version 0.16.0"
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "set --home nodejs 16.7.0" ""
  stub_asdf "install ruby rbx-5.0" "(mock ruby install)"
  stub_asdf "set --home ruby rbx-5.0" ""

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   16.7.0
ruby     ______   rbx-5.0

Updates found: 2

asdf install nodejs 16.7.0
(mock nodejs install)
asdf set --home nodejs 16.7.0

asdf install ruby rbx-5.0
(mock ruby install)
asdf set --home ruby rbx-5.0
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 16.7.0
$asdf_mock set --home nodejs 16.7.0
$asdf_mock install ruby rbx-5.0
$asdf_mock set --home ruby rbx-5.0
EOF
)"
}

@test "install the latest available versions of tools (0.15.0)" {
  asdf_current="$(cat <<EOF
nodejs          ______          No version set. Run "asdf <global|shell|local> nodejs <version>"
ruby            ______          No version set. Run "asdf <global|shell|local> nodejs <version>"
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "--version" "asdf version 0.15.0"
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "global nodejs 16.7.0" ""
  stub_asdf "install ruby rbx-5.0" "(mock ruby install)"
  stub_asdf "global ruby rbx-5.0" ""

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   16.7.0
ruby     ______   rbx-5.0

Updates found: 2

asdf install nodejs 16.7.0
(mock nodejs install)
asdf global nodejs 16.7.0

asdf install ruby rbx-5.0
(mock ruby install)
asdf global ruby rbx-5.0
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 16.7.0
$asdf_mock global nodejs 16.7.0
$asdf_mock install ruby rbx-5.0
$asdf_mock global ruby rbx-5.0
EOF
)"
}

@test "update to the latest available versions of tools" {
  asdf_current="$(cat <<EOF
Name    Version    Source                         Installed
nodejs  14.17.4    /home/example/.tool-versions   true
ruby    rbx-4.16   /home/example/.tool-versions   true
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "--version" "asdf version 0.16.0"
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "set --home nodejs 16.7.0" ""
  stub_asdf "install ruby rbx-5.0" "(mock ruby install)"
  stub_asdf "set --home ruby rbx-5.0" ""

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   14.17.4    16.7.0
ruby     rbx-4.16   rbx-5.0

Updates found: 2

asdf install nodejs 16.7.0
(mock nodejs install)
asdf set --home nodejs 16.7.0

asdf install ruby rbx-5.0
(mock ruby install)
asdf set --home ruby rbx-5.0
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 16.7.0
$asdf_mock set --home nodejs 16.7.0
$asdf_mock install ruby rbx-5.0
$asdf_mock set --home ruby rbx-5.0
EOF
)"
}

@test "update to the latest available versions of tools (0.15.0)" {
  asdf_current="$(cat <<EOF
nodejs  14.17.4    /home/example/.tool-versions
ruby    rbx-4.16   /home/example/.tool-versions
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "--version" "asdf version 0.15.0"
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "global nodejs 16.7.0" ""
  stub_asdf "install ruby rbx-5.0" "(mock ruby install)"
  stub_asdf "global ruby rbx-5.0" ""

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   14.17.4    16.7.0
ruby     rbx-4.16   rbx-5.0

Updates found: 2

asdf install nodejs 16.7.0
(mock nodejs install)
asdf global nodejs 16.7.0

asdf install ruby rbx-5.0
(mock ruby install)
asdf global ruby rbx-5.0
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 16.7.0
$asdf_mock global nodejs 16.7.0
$asdf_mock install ruby rbx-5.0
$asdf_mock global ruby rbx-5.0
EOF
)"
}

@test "nothing is updated when the tools are already up-to-date" {
  asdf_current="$(cat <<EOF
Name    Version   Source                         Installed
nodejs  16.7.0    /home/example/.tool-versions   true
ruby    rbx-5.0   /home/example/.tool-versions   true
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "--version" "asdf version 0.16.0"
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "set --home nodejs 16.7.0" ""
  stub_asdf "install ruby rbx-5.0" "(mock ruby install)"
  stub_asdf "set --home ruby rbx-5.0" ""

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   16.7.0    16.7.0
ruby     rbx-5.0   rbx-5.0

No updates available.
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
EOF
)"
}

@test "nothing is updated when the tools are already up-to-date (0.15.0)" {
  asdf_current="$(cat <<EOF
nodejs  16.7.0    /home/example/.tool-versions
ruby    rbx-5.0   /home/example/.tool-versions
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "--version" "asdf version 0.15.0"
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "set --home nodejs 16.7.0" ""
  stub_asdf "install ruby rbx-5.0" "(mock ruby install)"
  stub_asdf "set --home ruby rbx-5.0" ""

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   16.7.0    16.7.0
ruby     rbx-5.0   rbx-5.0

No updates available.
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
EOF
)"
}
