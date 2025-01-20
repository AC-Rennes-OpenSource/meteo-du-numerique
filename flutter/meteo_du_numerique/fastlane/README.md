fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### build_android

```sh
[bundle exec] fastlane build_android
```

Construire l'AppBundle Android

### deploy_to_testflight

```sh
[bundle exec] fastlane deploy_to_testflight
```

Déployer l'IPA sur TestFlight

### build_ios

```sh
[bundle exec] fastlane build_ios
```

Construire et (optionnellement) déployer l'IPA iOS sur TestFlight

### increment_version

```sh
[bundle exec] fastlane increment_version
```



### all

```sh
[bundle exec] fastlane all
```

Incrémenter la version et construire Android et iOS

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
