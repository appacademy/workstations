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

Follow the [procedure for setting up our computer environment][env-setup] from the curriculum.

### Clone the repo.

```
git clone https://github.com/appacademy/workstations.git ~/.workstation-admin
```

### Install workstation-admin.

This will add the extra packages and configuration needed to for this repo to work properly.

```
setup/install
```

### Clear app data.

#### Chrome

1. Clear all browsing data from "the beginning of time".
2. Quit (⌘Q)

#### Slack

Quit (⌘Q)

### Cache the settings.

```
setup/cache_app_data
```

[env-setup]:
[workstation-image-spec]: https://github.com/appacademy/instructors/blob/master/pre-cycle/workstation-image-spec.md
