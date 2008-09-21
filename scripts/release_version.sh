#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <tagname>"
	exit 1
fi

case "$1" in
	v*)
		tag="$1"
		;;
	[0-9]*)
		tag="v$1"
		;;
esac

ver=`echo $tag | sed -e 's/^v//'`

echo "About start release process of '`git rev-parse HEAD`' as '$tag'..."
echo "Press enter to continue."
read n

echo "1) Edit GUILT_VERSION in 'guilt'"
read n
vim guilt
git update-index guilt
git commit -s -m "Guilt $tag"

echo "2) Tag the commit with '$tag'"
read n
git tag -u C7958FFE -m "Guilt $tag" "$tag"

echo "3) Generate guilt-$ver.tar.gz"
read n
git archive --format=tar --prefix=guilt-$ver/ HEAD | gzip -9 > guilt-$ver.tar.gz

echo "4) Verify the tarball"
read n
(
	op=`pwd`
	cd /tmp
	tar xzf $op/guilt-$ver.tar.gz
	cd guilt-$ver
	make test
	make doc
)
rm -rf /tmp/guilt-$ver

echo "5) Profit"

echo "We're all done, have a nice day."
