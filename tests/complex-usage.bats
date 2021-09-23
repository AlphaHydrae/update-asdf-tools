#!/usr/bin/env bats
load "helper"

function setup() {
  common_setup
}

function teardown() {
  common_teardown
}

@test "the correct versions of tools are installed with a complex configuration file" {
  asdf_current="$(cat <<EOF
elixir   ______   No version set. Run "asdf <global|shell|local> nodejs <version>"
erlang   ______   No version set. Run "asdf <global|shell|local> nodejs <version>"
java     ______   No version set. Run "asdf <global|shell|local> nodejs <version>"
nodejs   ______   No version set. Run "asdf <global|shell|local> nodejs <version>"
python   ______   No version set. Run "asdf <global|shell|local> nodejs <version>"
ruby     ______   No version set. Run "asdf <global|shell|local> nodejs <version>"
EOF
)"

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
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
ruby = 2.7.2
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
  stub_asdf "install elixir 1.12.2-otp-24" "(mock elixir install)"
  stub_asdf "global elixir 1.12.2-otp-24" ""
  stub_asdf "install erlang 24.0.5" "(mock erlang install)"
  stub_asdf "global erlang 24.0.5" ""
  stub_asdf "install java openjdk-16.0.2" "(mock java install)"
  stub_asdf "global java openjdk-16.0.2" ""
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "global nodejs 16.7.0" ""
  stub_asdf "install python 3.9.6" "(mock python install)"
  stub_asdf "global python 3.9.6" ""
  stub_asdf "install ruby 2.7.2" "(mock ruby install)"
  stub_asdf "global ruby 2.7.2" ""

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
elixir   ______   1.12.2-otp-24
erlang   ______   24.0.5
java     ______   openjdk-16.0.2
nodejs   ______   16.7.0
python   ______   3.9.6
ruby     ______   2.7.2   jruby-9.2.19.0 available

Updates found: 6

asdf install elixir 1.12.2-otp-24
(mock elixir install)
asdf global elixir 1.12.2-otp-24

asdf install erlang 24.0.5
(mock erlang install)
asdf global erlang 24.0.5

asdf install java openjdk-16.0.2
(mock java install)
asdf global java openjdk-16.0.2

asdf install nodejs 16.7.0
(mock nodejs install)
asdf global nodejs 16.7.0

asdf install python 3.9.6
(mock python install)
asdf global python 3.9.6

asdf install ruby 2.7.2
(mock ruby install)
asdf global ruby 2.7.2
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
$asdf_mock install elixir 1.12.2-otp-24
$asdf_mock global elixir 1.12.2-otp-24
$asdf_mock install erlang 24.0.5
$asdf_mock global erlang 24.0.5
$asdf_mock install java openjdk-16.0.2
$asdf_mock global java openjdk-16.0.2
$asdf_mock install nodejs 16.7.0
$asdf_mock global nodejs 16.7.0
$asdf_mock install python 3.9.6
$asdf_mock global python 3.9.6
$asdf_mock install ruby 2.7.2
$asdf_mock global ruby 2.7.2
EOF
)"
}

@test "the correct updates of tools are made with a complex configuration file" {
  asdf_current="$(cat <<EOF
elixir   1.12.0-rc.0   /home/example/.tool-versions
erlang   24.0.3          /home/example/.tool-versions
java     adoptopenjdk-16.0.1+9   /home/example/.tool-versions
nodejs   13.14.0          /home/example/.tool-versions
python   3.9-dev           /home/example/.tool-versions
ruby     2.7.0           /home/example/.tool-versions
EOF
)"

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
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
ruby = 2.7.2
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
  stub_asdf "install elixir 1.12.2-otp-24" "(mock elixir install)"
  stub_asdf "global elixir 1.12.2-otp-24" ""
  stub_asdf "install erlang 24.0.5" "(mock erlang install)"
  stub_asdf "global erlang 24.0.5" ""
  stub_asdf "install java openjdk-16.0.2" "(mock java install)"
  stub_asdf "global java openjdk-16.0.2" ""
  stub_asdf "install nodejs 16.7.0" "(mock nodejs install)"
  stub_asdf "global nodejs 16.7.0" ""
  stub_asdf "install python 3.9.6" "(mock python install)"
  stub_asdf "global python 3.9.6" ""
  stub_asdf "install ruby 2.7.2" "(mock ruby install)"
  stub_asdf "global ruby 2.7.2" ""

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
elixir   1.12.0-rc.0             1.12.2-otp-24
erlang   24.0.3                  24.0.5
java     adoptopenjdk-16.0.1+9   openjdk-16.0.2
nodejs   13.14.0                 16.7.0
python   3.9-dev                 3.9.6
ruby     2.7.0                   2.7.2   jruby-9.2.19.0 available

Updates found: 6

asdf install elixir 1.12.2-otp-24
(mock elixir install)
asdf global elixir 1.12.2-otp-24

asdf install erlang 24.0.5
(mock erlang install)
asdf global erlang 24.0.5

asdf install java openjdk-16.0.2
(mock java install)
asdf global java openjdk-16.0.2

asdf install nodejs 16.7.0
(mock nodejs install)
asdf global nodejs 16.7.0

asdf install python 3.9.6
(mock python install)
asdf global python 3.9.6

asdf install ruby 2.7.2
(mock ruby install)
asdf global ruby 2.7.2
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
$asdf_mock install elixir 1.12.2-otp-24
$asdf_mock global elixir 1.12.2-otp-24
$asdf_mock install erlang 24.0.5
$asdf_mock global erlang 24.0.5
$asdf_mock install java openjdk-16.0.2
$asdf_mock global java openjdk-16.0.2
$asdf_mock install nodejs 16.7.0
$asdf_mock global nodejs 16.7.0
$asdf_mock install python 3.9.6
$asdf_mock global python 3.9.6
$asdf_mock install ruby 2.7.2
$asdf_mock global ruby 2.7.2
EOF
)"
}

@test "no updates with a complex configuration file" {
  asdf_current="$(cat <<EOF
elixir          1.12.2-otp-24   /home/example/.tool-versions
erlang          24.0.5          /home/example/.tool-versions
java            openjdk-16.0.2  /home/example/.tool-versions
nodejs          16.7.0          /home/example/.tool-versions
python          3.9.6           /home/example/.tool-versions
ruby            2.7.2           /home/example/.tool-versions
EOF
)"

  mkdir -p ~/.config/update-asdf-tools
  config="$(cat > ~/.config/update-asdf-tools/update-asdf-tools.conf <<EOF
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
ruby = 2.7.2
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

  run update-asdf-tools --yes
  assert_success

  assert_output "$(cat <<EOF

Updating plugins...

Checking available updates...
elixir   1.12.2-otp-24    1.12.2-otp-24
erlang   24.0.5           24.0.5
java     openjdk-16.0.2   openjdk-16.0.2
nodejs   16.7.0           16.7.0
python   3.9.6            3.9.6
ruby     2.7.2            2.7.2   jruby-9.2.19.0 available

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
