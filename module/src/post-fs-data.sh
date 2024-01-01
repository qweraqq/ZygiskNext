#!/system/bin/sh

MODDIR=${0%/*}
if [ "$ZYGISK_ENABLED" ]; then
  exit 0
fi

cd "$MODDIR"

MAGIC=$(cat ./magic)
MAGIC_PATH=/dev/xxxx_$MAGIC
export MAGIC
export MAGIC_PATH

if [ "$(which magisk)" ]; then
  for file in ../*; do
    if [ -d "$file" ] && [ -d "$file/zygisk" ] && ! [ -f "$file/disable" ]; then
      if [ -f "$file/post-fs-data.sh" ]; then
        cd "$file"
        log -p i -t "zygisk-sh" "Manually trigger post-fs-data.sh for $file"
        sh "$(realpath ./post-fs-data.sh)"
        cd "$MODDIR"
      fi
    fi
  done
fi

create_sys_perm() {
  mkdir -p $1
  chmod 555 $1
  chcon u:object_r:system_file:s0 $1
}

create_sys_perm $MAGIC_PATH

if [ -f $MODDIR/lib64/libxxxx.so ];then
  create_sys_perm $MAGIC_PATH/lib64
  cp $MODDIR/lib64/libxxxx.so $MAGIC_PATH/lib64/libxxxx.so
  chcon u:object_r:system_file:s0 $MAGIC_PATH/lib64/libxxxx.so
fi

if [ -f $MODDIR/lib/libxxxx.so ];then
  create_sys_perm $MAGIC_PATH/lib
  cp $MODDIR/lib/libxxxx.so $MAGIC_PATH/lib/libxxxx.so
  chcon u:object_r:system_file:s0 $MAGIC_PATH/lib/libxxxx.so
fi

[ "$DEBUG" = true ] && export RUST_BACKTRACE=1
unshare -m sh -c "./bin/xxxx-ptrace64 monitor &"
