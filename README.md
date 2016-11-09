# Workstation Admin

This is the repo where we manage all the admin scripts that the student
computers use. This includes:

* system restore scripts
* persistent machine-specific settings
* nightly app settings resets
* nightly repo fetches
* ad-hoc scripts (e.g. force-refresh Github tabs)

## Local Computer Data

We use the recovery partition to save some basic computer data such as
`id`, `pod`, and `station` so that it will persist between restores.
This data is used to set the device hostname and to keep track of
settings for some scripts.

### Settings script

To set this data, use the `./settings` script. This requires sudo. For
example:

```sh
sudo ./settings set id=15 pod=SoMa station=3
```

You can also remove a key by leaving the value blank:

```sh
sudo ./settings set id=3 pod= station=
```

There's another important feature: `set-local`. This allows you to set
data locally only. That way it will not persist after the computer
resets. Typically this is done when giving a computer to a job search
student:

```sh
sudo ./settings set-local student="Jane Doe" reset-data=false
```

### Specific meanings.

You'll need to update this data to stay in sync with these requirements:

|     key      |     meaning    |
| ------------ | -------------- |
| `id`         | ID # stuck on top of the machine. Every machine should have this set. |
| `pod`        | only set for machines that are on the floor |
| `station`    | # in the pod. Only set for floor machines |
| `student`    | name of student this computer is loaned to (only set if it is loaned) |
| `reset-data` | reset the desktop and app data every night (true/false) |

## Setup

You should only need to do this when creating a new disk image. You
**must** complete all the previous steps from the [workstation image
spec][workstation-image-spec] or `workstation-admin` will cache an old
version of the settings and overwrite your changes in the first night.

### Prepare to Clone.

Follow the same [steps to ready the computer for the
dotfiles][dotfiles-prep]. You don't need to download the dotfiles
though. That will happen automatically later.

### Clone the repo.

```
git clone https://github.com/appacademy/workstations.git ~/.workstation-admin
```

### Install workstation-admin.

This will install and configure the workstation, running the dotfiles
scripts, augmenting them, and adding hooks for maintenance scripts to
run.

```
setup/install
```

### Clear app data.

#### Atom

1. Remove the `~/.atom` directory.
2. Create it again with `mkdir`.
3. Run `maintenance/install_dotfiles`.
4. Open Atom.
5. Quit (⌘Q)

#### Chrome

1. Clear all browsing data from "the beginning of time".
2. Quit (⌘Q)
3. Run `setup/disable_chrome_signin_prompt`

#### Slack

Quit (⌘Q)

### Cache the settings.

```
setup/cache_app_data
```

[dotfiles-prep] https://github.com/appacademy/dotfiles/blob/master/README.md#preparing-your-machine-for-dotfiles
[workstation-image-spec]: https://github.com/appacademy/instructors/blob/master/pre-cycle/workstation-image-spec.md
