# scrcpy-web
Scrcpy web client running on Docker 🚀

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker Pulls](https://img.shields.io/docker/pulls/shmayro/scrcpy-web)](https://hub.docker.com/r/shmayro/scrcpy-web)
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
