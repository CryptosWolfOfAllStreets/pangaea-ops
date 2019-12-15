#!/bin/sh
# Author: P-OPS soph 

#requirement
# jq, bc

source config.sh

#test needs run in the same folder as the bls.key file
oneTimeSetUp() {
  cd ${HMYCLI_ABSOLUTE_FOLDER}
}

test_HMY_version() {
  #note the current hmy version v138 shows the version in the stderr
  output=$((${HMYCLIBIN} version) 2>&1)
  returncode=$?
  assertEquals 'Testing error code of hmy version which should be 0' "0" "${returncode}"
  assertContains 'Testing hmy version' "${output}" 'v179-f4cf946'
  #assertEquals 'Harmony (C) 2019. hmy, version v179-f4cf946 (@harmony.one 2019-11-26T22:27:26-0800)' "${output}"
}

test_HMY_Check_Balance() {
  output=$(${HMYCLIBIN} --node="https://api.s1.b.hmny.io/" balances one1yc06ghr2p8xnl2380kpfayweguuhxdtupkhqzw | jq ".[0].amount")
  returncode=$?
  assertEquals 'Testing error code of hmy balance check which should be 0' "0" "${returncode}"
  assertEquals "testing balance above 0 for one1yc06ghr2p8xnl2380kpfayweguuhxdtupkhqzw in pangaea" "1" "$(echo "${output} > 0" | bc -l)"
}

test_HMY_Known_Chain() {
  output=$(${HMYCLIBIN} blockchain known-chains --no-pretty)
  returncode=$?
  assertEquals 'Testing error code of hmy known chain test which should be 0' "0" "${returncode}"
  assertEquals '["mainnet","testnet","devnet"]' "${output}"
}

# Load and run shUnit2.
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${SHUNITPATH}
