#!/usr/bin/env bash

testFFFAll() {
  export LC_NUMERIC=C


  setupTestAssets || return 1
  local test_functions=("testFFF" "testFFFVisual")
  local ignored_tests=()
  
  bashTestRunner test_functions ignored_tests
  local runner_exit_code=$?
  
  cleanupArtifacts
  return $runner_exit_code
}
