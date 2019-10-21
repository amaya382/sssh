<h1 align="center">:closed_lock_with_key: Super SSH (SSSH)</h1>

A wrapper for interactive ssh clients

Keeping all the original ssh's features, you can use additional functions:

* :open_file_folder: Mount your local files to remote by the docker-like `--volume` option
* :clipboard: Clipboard over SSH
    * Copy text from your remote shell into your local clipboard
    * Paste text from your local clipboard into your remote shell
* :leftwards_arrow_with_hook: "Run commands in your local shell" from your remote shell

**No additional daemon or alternative command is needed! Just use `sssh` instead of `ssh`**

**Work w/ ssh-related tools like [amaya382/anyrc](https://github.com/amaya382/anyrc), [Russell91/sshrc](https://github.com/Russell91/sshrc), and autossh**



## :paperclip: Prerequisites
### Local
* `ssh` (or commands which have the same I/F as `ssh`)
* `openssh-sftp-server` (or other sftp servers compatible w/ `sshfs`)
* `xsel` or `xclip` or `pbcopy/pbpaste`

### Remote
* `sshfs`
* `user_allow_other` in `/etc/fuse.conf`



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
Without extra care,
```console
$ sssh [<ssh_opts_if_need_be>] <remote_host>
```

##### Remote copy
And then, in the remote shell,
```console
$ echo -ne 'from remote to local\n👍' | rcopy
```

Now

```
from remote to local
👍
```

is in your local clipboard!
Of course, you can copy text from any tools (e.g., `tmux`, `vim`) by using `rcopy` command in your settings.

##### Remote paste
Yank text in the local desktop,
```
from local to remote
👍
```

By `rpaste` command in the remote shell,
```console
$ rpaste
from local to remote
👍
```


### :leftwards_arrow_with_hook: Transparent reverse command execution
You can run commands in your *local* shell from remote shell.

#### Usage
Without extra care,
```console
$ sssh [<ssh_opts_if_need_be>] <remote_host>
```

And then, in the remote shell,
```console
$ echo 'hostname' | reval
<your local hostname>
```



## :wrench: Options
* `--ssh_cmd / SSSH_SSH_CMD`: string (`ssh`)
    * ssh command (run in local)
    * e.g., Work w/ `autossh`: `SSSH_SSH_CMD='autossh -M 0' sssh user@host`
* `--sftp_cmd / SSSH_SFTP_CMD`: string (`/usr/lib/openssh/sftp-server`)
    * sftp command (run in local)
* `--sshfs_cmd / SSSH_SSHFS_CMD`: string (`sshfs`)
    * sshfs command (run in remote)
* `--sshfs_ssh_cmd / SSSH_SSHFS_SSH_CMD`: string (`ssh`)
    * `-o ssh_command` in sshfs (run in remote)
    * e.g., Work w/ `autossh`: `SSSH_SSHFS_SSH_CMD='autossh -M 0' sssh user@host`
* `--sshfs_use_remote_uid / SSSH_SSHFS_USE_REMOTE_UID`: boolean (`true`)
    * Use remote uid for mounting
* `--sshfs_use_allow_other / SSSH_SSHFS_USE_ALLOW_OTHER`: boolean (`true`)
    * Use `allow_other` for mounting
* `--sshfs_use_cache / SSSH_SSHFS_USE_CACHE`: boolean (`false`)
    * Use cache in sshfs
* `--enable_eval_and_clipboard / SSSH_ENABLE_EVAL_AND_CLIPBOARD`: boolean (`true`)
    * Enable reverse eval and remote clipboard
* `--remote_copy_cmd_name / SSSH_REMOTE_COPY_CMD_NAME`: string (`rcopy`)
    * Name of command for copying in the remote shell
* `--remote_paste_cmd_name / SSSH_REMOTE_PASTE_CMD_NAME`: string (`rpaste`)
    * Name of command for pasting in the remote shell
* `--reverse_eval_cmd_name / SSSH_REVERSE_EVAL_CMD_NAME`: string (`reval`)
    * Name of command for evaluating commands in the local shell

