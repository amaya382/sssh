# sssh
ssh with sshfs

You can bring local files into remote by using a `--volume` option like the `docker` command's `--volume` option.
It will be automatically mounted and unmounted by sshfs.


## Prerequisites
### Local
* `ssh`
* `openssh-sftp-server`

### Remote
* `sshfs`


## Usage
```sh
source sssh.sh
sssh --volume <local_dir>:<remote_dir> <remote_host> [<ssh_opts_such_as_port_number>]
```

