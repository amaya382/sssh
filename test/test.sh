#!/bin/bash

# # Additional prerequisites
# ## Local
# * autossh
# ## Remote
# * autossh

ssh_remote="$1"
shift
ssh_opts="$@" # shouldn't contain `-t` since we test sssh w/ `-t` automatically

prepare() {
  mkdir -p tmp
  echo foo > tmp/foo
}

clean() {
  rm -rf tmp
}

test_normal() {
  echo 'should work w/ volume and clipboard'
  ../sssh --volume tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts}

  echo 'should work w/ volume and clipboard'
  ../sssh --volume `pwd`/tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts}

  echo 'should work w/ volume and clipboard'
  ../sssh "${ssh_remote}" ${ssh_opts} --volume tmp:/tmp/sssh-test

  echo 'should work w/ volume'
  ../sssh --enable_eval_and_clipboard false --volume tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts}

  echo 'should work'
  ../sssh --enable_eval_and_clipboard false "${ssh_remote}" ${ssh_opts}

  echo 'should work w/ volume and clipboard (autossh/autossh)'
  SSSH_SSH_CMD='autossh -M 0' SSSH_SSHFS_SSH_CMD='autossh -M 0' ../sssh --volume tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts}

  echo 'should work w/ volume and clipboard (autossh/ssh)'
  SSSH_SSH_CMD='autossh -M 0' SSSH_SSHFS_SSH_CMD='invalid_ssh_cmd' ../sssh --volume tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts}
}

test_tty() {
  echo 'should work w/ volume and clipboard'
  ../sssh --volume tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts} -t bash

  echo 'should work w/ volume and clipboard'
  ../sssh --volume tmp:/tmp/sssh-test -t "${ssh_remote}" ${ssh_opts} bash

  echo 'should work w/ volume and clipboard'
  ../sssh "${ssh_remote}" ${ssh_opts} --volume tmp:/tmp/sssh-test -t bash

  echo 'should work w/ volume'
  ../sssh --enable_eval_and_clipboard false --volume tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts} -t bash

  echo 'should work'
  ../sssh --enable_eval_and_clipboard false "${ssh_remote}" ${ssh_opts} -t bash

  echo 'should work w/ volume and clipboard (autossh/autossh)'
  SSSH_SSH_CMD='autossh -M 0' SSSH_SSHFS_SSH_CMD='autossh -M 0' ../sssh --volume tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts} -t bash

  echo 'should work w/ volume and clipboard (autossh/ssh)'
  SSSH_SSH_CMD='autossh -M 0' SSSH_SSHFS_SSH_CMD='invalid_ssh_cmd' ../sssh --volume tmp:/tmp/sssh-test "${ssh_remote}" ${ssh_opts} -t bash
}

prepare
trap 'clean' 0 1 2 3 15
test_normal
test_tty

