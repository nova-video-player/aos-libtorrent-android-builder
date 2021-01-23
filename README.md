### libtorrent-android-builder

A simple shell script to cross-compile libtorrent project for Android targets.

Builds the binaries and libs using dynamic linking.

Typical usage:
```
bash ./build.sh -a $ARCH
```

$ARCH can be either: arm arm64 x86 x86_64

Requirements:
- NDK installed
- some dev tools
