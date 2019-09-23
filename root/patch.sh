#!/bin/sh

REPOS='llvm clang lld libunwind compiler-rt libcxx libcxxabi'
ROOT=$(dirname $(readlink -f "$0"))
SRC=/src

cd $SRC || $(echo 'failed to change directory' && exit 1)

for REPO in $REPOS; do
  PATCHES="$(ls -r -1 $ROOT/patch/$REPO-*.patch 2>/dev/null)"
  NUMPATCHES="$(ls -r -1 $ROOT/patch/$REPO-*.patch 2>/dev/null | wc -l)"
  NUMPATCH=0
  for PATCH in $PATCHES; do
    NUMPATCH=$(($NUMPATCH+1))
    echo -n "unpatching $REPO ($NUMPATCH/$NUMPATCHES)... "
    if ! patch -R -p1 --dry-run -s -f -d $SRC/$REPO -i $PATCH >/dev/null; then
      echo fail
    else
      patch -R -p1 -s -f -d $SRC/$REPO -i $PATCH >/dev/null
      echo success
    fi
  done
done

for REPO in $REPOS; do
  PATCHES="$(ls -1 $ROOT/patch/$REPO-*.patch 2>/dev/null)"
  NUMPATCHES="$(ls -1 $ROOT/patch/$REPO-*.patch 2>/dev/null | wc -l)"
  NUMPATCH=0
  for PATCH in $PATCHES; do
    NUMPATCH=$(($NUMPATCH+1))
    echo -n "patching $REPO ($NUMPATCH/$NUMPATCHES)... "
    if ! patch -p1 --dry-run -s -f -d $SRC/$REPO -i $PATCH >/dev/null; then
      echo fail
    else
      patch -p1 -s -f -d $SRC/$REPO -i $PATCH >/dev/null
      echo success
    fi
  done
done
