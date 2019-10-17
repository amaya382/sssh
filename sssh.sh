#!/bin/bash

sssh() {
  # opts
  use_remote_uid=1
  use_allow_other=1

  local_dir=''
  remote_dir=''
  while [[ -n "$1" ]]; do
    case "$1" in
      --volume )
        local_dir="$(echo $2 | cut -d ':' -f 1)"
        remote_dir="$(echo $2 | cut -d ':' -f 2)"
        shift ;;
      -b | -c | -D | -E | -e | -F | -I | -i | -J | -L | -l | -m | -O | -o | -p | -Q | -R | -S | -W | -w )
        if [ "$1" = '-p' ]; then
          SSH_PORT="$2"
        fi
        SSH_OPTS="${SSH_OPTS} $1 $2"; shift ;;
      -* )
        SSH_OPTS="${SSH_OPTS} $1" ;;
      * )
        if [ -z "${SSH_REMOTE:+_}" ]; then
          SSH_REMOTE="$1"
        fi; ;;
    esac
    shift
  done

  : "${SSH_PORT=22}"

  if [ "$(ssh ${SSH_REMOTE} -p ${SSH_PORT} [ -e ${remote_dir} ] && echo o || echo x)" = "x" ]; then
    ssh ${SSH_REMOTE} -p ${SSH_PORT} mkdir -p "${remote_dir}"
    echo "Created ${remote_dir} on ${SSH_REMOTE}"
  else
    if [ -n "$(ssh ${SSH_REMOTE} -p ${SSH_PORT} ls ${remote_dir})" ]; then
      echo "${SSH_REMOTE}:${remote_dir} already exists and is not empty."
      return
    fi
  fi

  if [ -v use_remote_uid ]; then
    uid=$(ssh ${SSH_REMOTE} -p ${SSH_PORT} id -u \$\(whoami\))
  fi

  tmp_dir=$(mktemp -d)
  trap "rm -rf ${tmp_dir}" 0 1 2 3 15
  fifo=${tmp_dir}/fifo
  mkfifo -m600 "${fifo}" && \
  < "${fifo}" /usr/lib/openssh/sftp-server \
  | ssh "${SSH_REMOTE}" -p "${SSH_PORT}" \
    sshfs -C -o slave $([ -v use_allow_other ] && echo "-o allow_other") ${uid/#/-o uid=} -o cache=no -o transform_symlinks -o follow_symlinks \
        ":${local_dir}" "${remote_dir}" \
  > "${fifo}" &
  sshfs_proc="$!"
  trap "{ kill ${sshfs_proc} && wait ${sshfs_proc} } 2> /dev/null" 0 1 2 3 15
  ssh "${SSH_REMOTE}" ${SSH_OPTS}
}
