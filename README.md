# sssh
ssh with sshfs

You can use a `--volume` option like the `docker` command's `--volume` option.
It will be automatically mounted and unmounted by sshfs.


## Prerequisites
* `ssh`
* `scp`
* `sshfs`


## Usage

```
source sssh.sh
sssh --volume <local_dir>:<remote_dir> <remote_host> [<ssh_opts_such_as_port_number>]
```


## Limitation
* `local_dir` will be mounted on `${local_dir}.mount`
* `remote_dir` must be empty

TODO: When face these limitations, confirm interactively (?)

