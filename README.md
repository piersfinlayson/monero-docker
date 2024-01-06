# monero-docker

Repo to build and run a monero container.

## Building

```
./build.sh <monero_version>
```

For example:

```
./build.sh 0.18 0.18.01
```

This builds ```piersfinlayson/monero:0.18.01```, using monero branch ```release-v0.18``` and uploads it to hub.docker.com.

## Running

```
run.sh <old_container_version> <new_container_version>
```

For example:
```
run.sh 0.18.01 0.18.02
```

Will stop and remove any old container of version 0.18.01, and run a new instance of version 0.18.02.

Will succeed even if there isn't an old version running.

