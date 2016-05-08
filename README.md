# Workstation Admin

This is the repo where we manage all the admin scripts that the student
computers use. This includes:

* system restore scripts
* persistent machine-specific settings
* nightly app settings resets
* nightly repo fetches
* ad-hoc scripts (e.g. force-refresh Github tabs)

## Setup

You should only need to do this when creating a new disk image. You
**must** complete all the previous steps from the [workstation image
spec][workstation-image-spec] or `workstation-admin` will cache an old
version of the settings and overwrite your changes in the first night.

### Hack Chrome.

One final setting must be attended to before we cache.

Chrome will always prompt the user to signin on startup. We don't want
this. We want it to just display a new tab. Unfortunately, there's
no configuration for this, but you can hack it.

Make sure you quit (⌘Q) Chrome before running this script.

```
setup/disable_chrome_signin_prompt
```

### Cache the settings.

```
setup/cache_app_data
```

### Install the hooks.

This will install all the necessary hooks for the admin scripts to run.

```
setup/install
```

[workstation-image-spec]: https://github.com/appacademy/instructors/blob/master/pre-cycle/workstation-image-spec.md
