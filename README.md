# scrcpy-web
Scrcpy web client running on Docker 🚀

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker Pulls](https://img.shields.io/docker/pulls/shmayro/scrcpy-web)](https://hub.docker.com/r/shmayro/scrcpy-web)
[![GitHub Release](https://img.shields.io/github/v/release/shmayro/ws-scrcpy-docker)](https://github.com/shmayro/ws-scrcpy-docker/releases)
[![GitHub Issues](https://img.shields.io/github/issues/shmayro/ws-scrcpy-docker)](https://github.com/shmayro/ws-scrcpy-docker/issues)
[![GitHub Stars](https://img.shields.io/github/stars/shmayro/ws-scrcpy-docker?style=social)](https://github.com/shmayro/ws-scrcpy-docker/stargazers)

### How to connect devices during scrcpy-web startup
```dockerfile
services:
  dockerify-android:
    container_name: dockerify-android
    image: shmayro/dockerify-android:latest
    build:
      context: .
    ports:
      - "5555:5555"
    volumes:
      - ./data:/data
      - ./extras:/extras
    environment:
      DNS: one.one.one.one
      RAM_SIZE: 2048
      # Optional screen resolution in WIDTHxHEIGHT format
      SCREEN_RESOLUTION: 720x720
      # Optional screen density (dpi)
      SCREEN_DENSITY: 227
      ROOT_SETUP: 0 # set to 1 to enable rooting
      GAPPS_SETUP: 0 # set to 1 to install PICO GAPPS
      ARM_TRANSLATION: 1 # set to 1 to enable ARM translation (allows ARM64 apps)
    privileged: true
    devices:
      - /dev/kvm

  scrcpy-web:
    container_name: scrcpy-web
    restart: unless-stopped
    image: shmayro/scrcpy-web:latest
    privileged: true
    ports:
      - 8000:8000
    depends_on:
      dockerify-android:
        condition: service_healthy
    command: >
      sh -c "
        adb connect dockerify-android:5555 &&
        npm start
      "
```

### Versioning and Releases

scrcpy-web uses GitHub Releases as the source of truth for stable versions. Publishing a release such as `v1.2.3` creates matching multi-arch (`linux/amd64`, `linux/arm64`) Docker image tags: `1.2.3`, `1.2`, `1`, and `latest`.

Builds from the `main` branch are published as development images using `edge` and `sha-<short-sha>` tags.

### Audio

The web client does not stream audio. Upstream [ws-scrcpy](https://github.com/NetrisTV/ws-scrcpy) has no audio support, and its maintainer has no plans to add it ([NetrisTV/ws-scrcpy#380](https://github.com/NetrisTV/ws-scrcpy/issues/380)).

The Android side does produce audio, so if you need sound, use the native [scrcpy](https://github.com/Genymobile/scrcpy) client (v2.0+), which forwards audio over ADB:

```bash
adb connect localhost:5555
scrcpy -s localhost:5555
```

On Android 11 (the [dockerify-android](https://github.com/Shmayro/dockerify-android) image), the device must be unlocked when scrcpy starts, otherwise audio capture fails.
