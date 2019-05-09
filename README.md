# Workstation Admin

This is the repo where we manage all the admin scripts that the student
computers use. This includes:

* system restore scripts
* nightly app settings resets
* nightly repo fetches
* GCA bash function

## Setup

You should only need to do this when creating a new disk image. You
**must** complete all the previous steps from the [workstation image
spec][workstation-image-spec] or `workstation-admin` will cache an old
version of the settings and overwrite your changes in the first night.

### Disable SIP

Apple has an important security measure called **System Integrity
Protection** that prevents certain changes to system files even in
`root` mode. This unfortunately interferes with the admin install
scripts. However, it does not interfere with everyday operation, so you
only need to do this on the machine where you create the workstation
image.

1. Restart the machine in recovery mode (hold down ⌘R).
2. Click on the **Utilities** menu and choose **Terminal**.
3. Enter the command `csrutil disable`. This will disable SIP.
4. Restart the machine again.

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

[dotfiles-prep]: https://github.com/appacademy/dotfiles/blob/master/README.md#preparing-your-machine-for-dotfiles
[workstation-image-spec]: https://github.com/appacademy/instructors/blob/master/pre-cycle/workstation-image-spec.md
