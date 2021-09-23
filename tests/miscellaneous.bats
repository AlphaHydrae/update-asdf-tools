#!/usr/bin/env bats
load "helper"

function setup() {
  common_setup
}

function teardown() {
  common_teardown
}

@test "print the version" {
  run update-asdf-tools --version
  assert_success
  assert_output "update-asdf-tools 0.0.0"
  assert_asdf_not_called
}
