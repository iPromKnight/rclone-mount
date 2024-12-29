# Rclone Mount Wrapper

## ENV VARS

| Variable                | Description                                                    | Default Value         |
|-------------------------|----------------------------------------------------------------|-----------------------|
| USE_MMAP                | Enable memory-mapped I/O for better performance                | true                  |
| ENABLE_RC               | Enable rclone remote control (RC) and web GUI                  | true                  |
| ENABLE_BANDWIDTH_LIMIT  | Enable Bandwith limiter                                        | false                 |
| BANDWIDTH_LIMIT         | Set the bandwidth limit                                        | off                   |
| CACHE_DIR               | Directory to store cache files                                 | /cache                |
| BUFFER_SIZE             | Size of the in-memory buffer for transfers                     | 1M                    |
| DIR_CACHE_TIME          | How long to cache directory listings                           | 10s                   |
| TIMEOUT                 | Operation timeout for transfers                                | 10m                   |
| UMASK                   | File permissions mask                                          | 002                   |
| VFS_CACHE_MIN_FREE_SPACE| Minimum free space required for VFS cache                      | off                   |
| VFS_CACHE_MAX_AGE       | Maximum age of cached files in VFS                             | 24h                   |
| VFS_MAX_CACHE_SIZE      | Maximum size of the VFS cache                                  | 100G                  |
| VFS_CACHE_MODE          | Cache mode for VFS (off, minimal, writes, full)                | writes                |
| VFS_READ_CHUNK_SIZE     | Initial size of chunks read from remote                        | 5M                    |
| VFS_READ_CHUNK_LIMIT    | Maximum size of read chunks                                    | 64M                   |
| LOG_LEVEL               | Logging level for rclone (INFO, DEBUG, ERROR)                  | INFO                  |
| MOUNTNAME               | Name of the remote being mounted                               | _(no default)_        |
| ALLOW_NON_EMPTY         | Allow none empty dirs                                          | true                  |
| ALLOW_OTHER             | Allow other users                                              | true                  |
| ASYNC_READ              | Enable async read                                              | true                  |
| PUID                    | User Id                                                        | 1000                  |
| GUID                    | Group Id                                                       | 1000                  |


## Example Docker RUN
```bash
docker run -d \
  -e MOUNTNAME="torbox:" \
  -p 5572:5572 \
  -v /path/to/rclone.conf:/data/rclone.conf \
  -v /path/to/cache:/cache \
  -v /mnt/mount:/mnt \
  --name torbox-webdav \
  ipromknight/rclone-mount:latest
```
