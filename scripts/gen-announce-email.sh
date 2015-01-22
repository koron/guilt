#!/bin/bash

USAGE="$0 <rev> <prev_rev>"

rev="$1"
prev_rev="$2"

if [ -z "$rev" -o -z "$prev_rev" ]; then
	echo $USAGE >&2
	exit 1
fi

(cat << DONE
Guilt <<REV>> is available for download.

Guilt (Git Quilt) is a series of shell scripts which add a Mercurial
queues-like functionality and interface to git.

Tarballs:
http://guilt.31bits.net/src/

Git repo:
git://repo.or.cz/guilt.git


<<SUMMARY>>

As always, patches, and other feedback is welcome.

Josef "Jeff" Sipek.

------------
Changes since <<PREV_REV>>:

DONE
) | sed -e "s/<<REV>>/$rev/g" -e "s/<<PREV_REV>>/$prev_rev/g"

git log --no-merges $prev_rev..$rev | git shortlog | cat
