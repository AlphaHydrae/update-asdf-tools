#!/usr/bin/env bats
load "helper"

function setup() {
  common_setup
}

function teardown() {
  common_teardown
}

@test "install the latest matching versions of tools using global regular expression filters" {
  asdf_current="$(cat <<EOF
Name            Version         Source           Installed
nodejs          ______          ______           true
ruby            ______          ______           true
EOF
)"

  stub_asdf "plugin update --all" ""
  stub_asdf "--version" "asdf version 0.16.0"
  stub_asdf "current" "$asdf_current"
  stub_asdf "list all nodejs" "$(cat "${data_dir}/nodejs.txt")"
  stub_asdf "list all ruby" "$(cat "${data_dir}/ruby.txt")"
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "set --home nodejs 16.7.0" ""
  stub_asdf "install ruby 3.0.2" "(mock ruby install)"
  stub_asdf "set --home ruby 3.0.2" ""

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
[versions]
* =~ ^\d+
* !=~ \-dev$
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   16.7.0
ruby     ______   3.0.2

Updates found: 2

asdf install nodejs 16.7.0
(mock nodejs install)
asdf set --home nodejs 16.7.0

asdf install ruby 3.0.2
(mock ruby install)
asdf set --home ruby 3.0.2
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
$asdf_mock install ruby 3.0.2
$asdf_mock set --home ruby 3.0.2
EOF
)"
}

@test "install the latest matching versions of tools using global regular expression filters (0.15.0)" {
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
  stub_asdf "install ruby 3.0.2" "(mock ruby install)"
  stub_asdf "global ruby 3.0.2" ""

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
[versions]
* =~ ^\d+
* !=~ \-dev$
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   16.7.0
ruby     ______   3.0.2

Updates found: 2

asdf install nodejs 16.7.0
(mock nodejs install)
asdf global nodejs 16.7.0

asdf install ruby 3.0.2
(mock ruby install)
asdf global ruby 3.0.2
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
$asdf_mock install ruby 3.0.2
$asdf_mock global ruby 3.0.2
EOF
)"
}

@test "install the latest matching versions of tools using tool-specific regular expression filters" {
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
  stub_asdf "install nodejs 14.17.5" "(mock nodejs install)"
  stub_asdf "set --home nodejs 14.17.5" ""
  stub_asdf "install ruby jruby-9.2.19.0" "(mock ruby install)"
  stub_asdf "set --home ruby jruby-9.2.19.0" ""

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
[versions]
nodejs =~ ^14
ruby =~ ^jruby
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   14.17.5
ruby     ______   jruby-9.2.19.0

Updates found: 2

asdf install nodejs 14.17.5
(mock nodejs install)
asdf set --home nodejs 14.17.5

asdf install ruby jruby-9.2.19.0
(mock ruby install)
asdf set --home ruby jruby-9.2.19.0
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 14.17.5
$asdf_mock set --home nodejs 14.17.5
$asdf_mock install ruby jruby-9.2.19.0
$asdf_mock set --home ruby jruby-9.2.19.0
EOF
)"
}

@test "install the latest matching versions of tools using tool-specific regular expression filters (0.15.0)" {
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
  stub_asdf "install nodejs 14.17.5" "(mock nodejs install)"
  stub_asdf "global nodejs 14.17.5" ""
  stub_asdf "install ruby jruby-9.2.19.0" "(mock ruby install)"
  stub_asdf "global ruby jruby-9.2.19.0" ""

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
[versions]
nodejs =~ ^14
ruby =~ ^jruby
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   14.17.5
ruby     ______   jruby-9.2.19.0

Updates found: 2

asdf install nodejs 14.17.5
(mock nodejs install)
asdf global nodejs 14.17.5

asdf install ruby jruby-9.2.19.0
(mock ruby install)
asdf global ruby jruby-9.2.19.0
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 14.17.5
$asdf_mock global nodejs 14.17.5
$asdf_mock install ruby jruby-9.2.19.0
$asdf_mock global ruby jruby-9.2.19.0
EOF
)"
}

@test "install the latest matching versions of tools using mixed regular expression filters" {
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
  stub_asdf "install nodejs 15.14.0" "(mock nodejs install)"
  stub_asdf "set --home nodejs 15.14.0" ""
  stub_asdf "install ruby 3.0.2" "(mock ruby install)"
  stub_asdf "set --home ruby 3.0.2" ""

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
[versions]
* =~ ^\d+
nodejs =~ ^15
ruby !=~ \-dev$
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   15.14.0
ruby     ______   3.0.2

Updates found: 2

asdf install nodejs 15.14.0
(mock nodejs install)
asdf set --home nodejs 15.14.0

asdf install ruby 3.0.2
(mock ruby install)
asdf set --home ruby 3.0.2
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 15.14.0
$asdf_mock set --home nodejs 15.14.0
$asdf_mock install ruby 3.0.2
$asdf_mock set --home ruby 3.0.2
EOF
)"
}

@test "install the latest matching versions of tools using mixed regular expression filters (0.15.0)" {
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
  stub_asdf "install nodejs 15.14.0" "(mock nodejs install)"
  stub_asdf "global nodejs 15.14.0" ""
  stub_asdf "install ruby 3.0.2" "(mock ruby install)"
  stub_asdf "global ruby 3.0.2" ""

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
[versions]
* =~ ^\d+
nodejs =~ ^15
ruby !=~ \-dev$
EOF
)"

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
nodejs   ______   15.14.0
ruby     ______   3.0.2

Updates found: 2

asdf install nodejs 15.14.0
(mock nodejs install)
asdf global nodejs 15.14.0

asdf install ruby 3.0.2
(mock ruby install)
asdf global ruby 3.0.2
EOF
)"

  assert_asdf_called "$(cat <<EOF
$asdf_mock --version
$asdf_mock plugin update --all
$asdf_mock current
$asdf_mock list all nodejs
$asdf_mock list all ruby
$asdf_mock install nodejs 15.14.0
$asdf_mock global nodejs 15.14.0
$asdf_mock install ruby 3.0.2
$asdf_mock global ruby 3.0.2
EOF
)"
}
