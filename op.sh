#! /bin/bash

. ./functions/wget.sh
. ./functions/text.sh
. ./functions/msg.sh
. ./functions/login.sh
. ./functions/loop.sh
. ./functions/friend.sh
. ./op/admin.sh
. ./op/op.sh
. ./op/normal.sh

touch "$piddir"/$$
trap "rm \"$piddir\"/$$" EXIT

case $uid in
# uasoft
1146759985 ) admin;;
# Ljk-uasoft
729601809 ) op;;
# Else
* ) normal;;
esac
exit 0
