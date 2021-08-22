#!/usr/bin/env bash
set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
root_dir="$(dirname "$script_dir")"
bin_dir="${root_dir}/bin"
data_dir="${root_dir}/tests/data"
mocks_dir="${root_dir}/tests/mocks"
asdf_mock="${mocks_dir}/asdf"
new_line=$'\n'

tmp_dirs=()
trap "cleanup $tmp_dir" EXIT

function assert_asdf_called() {
  local expected_execution="$@"
  local executions="$(asdf_mock_executions)"

  test -n "$executions" || fail "expected asdf to be called but it was not"
  assert_equal "$executions" "$expected_execution"

  asdf_call_assertions=$(( $asdf_call_assertions + 1 ))
}

function assert_asdf_not_called() {
  [[ "$(asdf_mock_executions)" == "" ]] || fail "asdf was called: $(asdf_mock_executions)"
  asdf_call_assertions=$(( $asdf_call_assertions + 1 ))
}

function cleanup() {
  for dir in ${tmp_dirs[@]}; do
    test -n "$dir" && test -d "$dir" && rm -fr "$dir"
  done
}

function common_setup() {
  load 'libs/support/load'
  load 'libs/assert/load'

  tmp_dir=`mktemp -d -t update-asdf-tools.tests.XXXXXX`
  tmp_dirs+=("$tmp_dir")
  echo "Temporary directory: $tmp_dir"

  export ASDF_MOCK_SPY_FILE="${tmp_dir}/asdf-mock-spy"
  export ASDF_MOCK_STUBS_DIR="${tmp_dir}/asdf-mock-stubs"
  mkdir "$ASDF_MOCK_STUBS_DIR"

  PATH="$bin_dir:$mocks_dir:$PATH"

  twd="${tmp_dir}/twd"
  HOME="$twd"

  mkdir "$twd"
  cd "$twd"

  setup_mocks
}

function common_teardown() {
  verify
}

function fail() {
  local msg="$@"

  >&2 echo "TEST ERROR: $msg"
  exit 2
}

function setup_mocks() {
  test -n "$ASDF_MOCK_SPY_FILE" && echo -n "" > "$ASDF_MOCK_SPY_FILE"
  test -d "$ASDF_MOCK_STUBS_DIR" && rm -f "${ASDF_MOCK_STUBS_DIR}/*"
  asdf_call_assertions=0
}

function asdf_mock_executions() {
  cat "$ASDF_MOCK_SPY_FILE"
}

function stub_asdf() {
  local invocation="$1"
  local output="$2"

  echo -n "$output" > "${ASDF_MOCK_STUBS_DIR}/$invocation"
}

function verify() {
  assert_equal "total asdf calls assertions $asdf_call_assertions" "total asdf calls assertions 1"
}
