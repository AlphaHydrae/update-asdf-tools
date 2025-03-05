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
  assert_output "update-asdf-tools 1.0.2"
  assert_asdf_not_called
}
