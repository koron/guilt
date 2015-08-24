#!/bin/bash
#
# Test the pop code
#

source "$REG_DIR/scaffold"

cmd setup_repo

cmd guilt push --all

cmd list_files

#
# incremental pop by 1
#
guilt series | _tac | while read n ; do
	cmd guilt pop

	cmd list_files
done

#
# pop when there is nothing to pop
#

shouldfail guilt pop

#
# push all
#
cmd guilt push --all

#
# pop by name (initially all applied)
#
guilt series | _tac | while read n ; do
	cmd guilt pop $n

	cmd list_files

	cmd guilt push --all
done

#
# pop by name (incrementally)
#
guilt series | _tac | while read n ; do
	cmd guilt pop $t

	cmd list_files
done

#
# push all
#
cmd guilt push --all

npatches=`guilt series | wc -l`
for n in `_seq -2 $npatches`; do
	if [ $n -gt 0 ]; then
		cmd guilt pop -n $n
	else
		shouldfail guilt pop -n $n
	fi

	cmd list_files

	cmd guilt push --all
done

cmd list_files

# FIXME:
#   --all
#   -a
#   -n with some patches already applied
