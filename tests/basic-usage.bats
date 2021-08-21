#!/usr/bin/env bats
load "helper"

function setup() {
  common_setup
}

function teardown() {
  common_teardown
}

@test "it works" {
  stub_asdf "current" ""
  run update-asdf-tools
  assert_success
  assert_output
  assert_asdf_called "$asdf_mock" current
}
