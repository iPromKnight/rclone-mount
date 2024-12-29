#!/bin/sh
set -eu  # Exit on error and undefined variables

USE_MMAP=${USE_MMAP:-true}
ENABLE_RC=${ENABLE_RC:-true}
ENABLE_BANDWIDTH_LIMIT=${ENABLE_BANDWIDTH_LIMIT:-false}
ALLOW_NON_EMPTY=${ALLOW_NON_EMPTY:-true}
ALLOW_OTHER=${ALLOW_OTHER:-true}
ASYNC_READ=${ASYNC_READ:-true}

echo "Starting rclone WebDAV mount..."

if [ ! -f /data/rclone.conf ]; then
    echo "Error: Config file /data/rclone.conf not found!"
    exit 1
fi

if [ -z "$MOUNTNAME" ]; then
    echo "Error: MOUNTNAME not set!"
    exit 1
fi

# Log default values
echo ""
echo "-------------------------------------"
echo "Cache Directory: ${CACHE_DIR:-/cache}"
echo "Buffer Size: ${BUFFER_SIZE:-1M}"
echo "Dir Cache Time: ${DIR_CACHE_TIME:-10s}"
echo "Timeout: ${TIMEOUT:-10m}"
echo "VFS Cache Mode: ${VFS_CACHE_MODE:-full}"
echo "VFS Cache Size: ${VFS_MAX_CACHE_SIZE:-10G}"
echo "VFS Cache Age: ${VFS_CACHE_MAX_AGE:-1h}"
echo "VFS Min Free Space: ${VFS_MIN_FREE_SPACE:-off}"
echo "VFS Read Chunk Size: ${VFS_READ_CHUNK_SIZE:-4M}"
echo "VFS Read Chunk Limit: ${VFS_READ_CHUNK_LIMIT:-16M}"
echo "UMask: ${UMASK:-002}"
echo "Log Level: ${LOG_LEVEL:-INFO}"
echo "Remote: $MOUNTNAME"
echo "Mount Path: /data/mnt"
echo "UID: ${PUID:-1000}"
echo "GID: ${PGID:-1000}"
echo "Bandwidth Limit: ${BANDWIDTH_LIMIT:-off}"
echo "Enable RC: $ENABLE_RC"
echo "Enable Bandwidth Limit: $ENABLE_BANDWIDTH_LIMIT"
echo "Allow Non-Empty: $ALLOW_NON_EMPTY"
echo "Allow Other: $ALLOW_OTHER"
echo "Use MMAP: $USE_MMAP"
echo "Async Read: $ASYNC_READ"
echo "-------------------------------------"
echo ""

# Base rclone command
CMD="rclone mount $MOUNTNAME /data/mnt \
       --config=/data/rclone.conf \
       --bind=0.0.0.0 \
       --log-level ${LOG_LEVEL:-INFO} \
       --cache-dir ${CACHE_DIR:-/cache} \
       --buffer-size=${BUFFER_SIZE:-1M} \
       --dir-cache-time=${DIR_CACHE_TIME:-10s} \
       --timeout=${TIMEOUT:-10m} \
       --umask=${UMASK:-002} \
       --uid=${PUID:-1000} \
       --gid=${PGID:-1000} \
       --vfs-cache-min-free-space=${VFS_MIN_FREE_SPACE:-off} \
       --vfs-cache-max-age=${VFS_CACHE_MAX_AGE:-24h} \
       --vfs-cache-max-size=${VFS_MAX_CACHE_SIZE:-100G} \
       --vfs-cache-mode=${VFS_CACHE_MODE:-writes} \
       --vfs-read-chunk-size-limit=${VFS_READ_CHUNK_LIMIT:-64M} \
       --vfs-read-chunk-size=${VFS_READ_CHUNK_SIZE:-5M} \
       --no-traverse \
       --ignore-existing \
       --poll-interval=0"

# Conditionally allow non-empty directories
if [ "$ALLOW_NON_EMPTY" = "true" ] || [ "$ALLOW_NON_EMPTY" = "1" ]; then
    CMD="$CMD --allow-non-empty"
    echo "Allowing non-empty directories."
fi

# Conditionally allow other users
if [ "$ALLOW_OTHER" = "true" ] || [ "$ALLOW_OTHER" = "1" ]; then
    CMD="$CMD --allow-other"
    echo "Allowing other users."
fi

# Conditionally enable async read
if [ "$ASYNC_READ" = "true" ] || [ "$ASYNC_READ" = "1" ]; then
    CMD="$CMD --async-read=true"
    echo "Using async read."
fi

# Conditionally enable MMAP
if [ "$USE_MMAP" = "true" ] || [ "$USE_MMAP" = "1" ]; then
    CMD="$CMD --use-mmap"
    echo "Using MMAP (memory-mapped I/O)."
fi

# Conditionally enable remote control (RC) features
if [ "$ENABLE_RC" = "true" ] || [ "$ENABLE_RC" = "1" ]; then
    CMD="$CMD \
       --rc \
       --rc-addr=0.0.0.0:5572 \
       --rc-enable-metrics \
       --rc-no-auth \
       --rc-web-gui \
       --rc-web-gui-no-open-browser"
    echo "Remote Control (RC) enabled."
fi

# Conditionally enable bandwidth limiting
if [ "$ENABLE_BANDWIDTH_LIMIT" = "true" ] || [ "$ENABLE_BANDWIDTH_LIMIT" = "1" ]; then
    CMD="$CMD --bwlimit ${BANDWIDTH_LIMIT:-off}"
    echo "Bandwidth limiting enabled."
fi

# Execute the final command
exec $CMD