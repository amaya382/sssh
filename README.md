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
./sssh [<ssh_opts_such_as_port_number>] --volume <local_dir>:<remote_dir> <remote_host>
```

### Other options
* `--ssh_cmd`: string (`ssh`)
    * ssh command
* `--sftp_cmd`: string (`/usr/lib/openssh/sftp-server`)
    * sftp command
* `--sshfs_cmd`: string (`sshfs`)
    * sshfs command run in remote
* `--use_remote_uid`: boolean (`true`)
    * Use remote uid for mounting
* `--use_allow_other`: boolean (`true`)
    * Use `allow_other` for mounting
