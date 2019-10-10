#!/bin/bash

sssh() {
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

  if [ "$local_dir" != "" ]; then
    # if not exist local_dir, create it
    if [ ! -e "${local_dir}" ]; then
      mkdir -p "${local_dir}"
    fi

    # check remote_dir
    # if not exist, transfer local_dir
    if [ "$(ssh ${SSH_REMOTE} [ -e ${remote_dir} ] && echo o || echo x)" = "x" ]; then
      scp -q -P "${SSH_PORT}" -r "${local_dir}" "${SSH_REMOTE}:${remote_dir}"
    else
      echo "${SSH_REMOTE}:${remote_dir} already exists."
      return
    fi

    trap "fusermount -u ${local_dir}.mount" 0 1 2 3 15
    mkdir -p "${local_dir}.mount"
    sshfs -p "${SSH_PORT}" "${SSH_REMOTE}:${remote_dir}" "${local_dir}.mount"
    ssh "${SSH_REMOTE}" ${SSH_OPTS}
  fi
}
