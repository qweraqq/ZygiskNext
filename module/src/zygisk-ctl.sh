MODDIR=${0%/*}/..
export MAGIC=$(cat $MODDIR/magic)
exec $MODDIR/bin/xxxx-ptrace64 ctl $*
