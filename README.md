<h1 align="center">:closed_lock_with_key: Super SSH (SSSH)</h1>

A wrapper for interactive ssh clients

Keeping all the original ssh's features, you can use additional functions:

* Mount your local files to remote by the docker-like `--volume` option
* :clipboard: Copy text from a remote shell into a local clipboard

**No additional daemon or alternative command is needed! Just use `sssh` instead of `ssh`**


## :paperclip: Prerequisites
### Local
* `ssh` (or commands which have the same I/F as `ssh`)
* `openssh-sftp-server` (or other sftp servers compatible w/ `sshfs`)
* `xsel` or `pbcopy` or `xclip`

### Remote
* `sshfs`


## :trident: Features
### :open_file_folder: Mount your local files to remote
You can bring local files into remote by using a --volume option like the docker command's --volume option. It will be automatically mounted and unmounted by sshfs.

#### Usage
Add a `--volume` option,
```sh
sssh [<ssh_opts_if_need_be>] --volume <local_dir>:<remote_dir> <remote_host>
```

### :clipboard: Clipboard over SSH
You can copy text from a remote shell into a local clipboard.

#### Usage
No need extra care,
```sh
sssh [<ssh_opts_if_need_be>] <remote_host>
```

And then, in the remote shell,
```sh
echo some-text | rcopy
```

Now "some-text" is in your local clipboard!
Of course, you can copy text from any tools (e.g., `tmux`, `vim`) by using `rcopy` command in your settings.


## :wrench: Options
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
* `--remote_copy_cmd_name`: string (`rcopy`)
    * Name of command for copying in the remote shell
