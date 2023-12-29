MODDIR=${0%/*}/..
export MAGIC=$(cat $MODDIR/magic)
exec $MODDIR/bin/xxxxd-ptrace64 ctl $*
