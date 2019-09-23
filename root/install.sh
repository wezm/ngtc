#!/bin/sh

TOOLS='clang lld'
PROJECTS='libunwind compiler-rt libcxx libcxxabi'
ARCH="$(uname -m)"
TARGETS='X86'
ROOT=$(dirname $(readlink -f "$0"))
SRC=/src

PATH=/"$ARCH"-pc-linux-musl/bin:"$PATH"
LD_LIBRARY_PATH=/"$ARCH"-pc-linux-musl/lib

if [ ! -d $SRC ]; then
  echo no sources found
  exit 1
fi

if [ ! -d $ROOT/build ]; then
  mkdir $ROOT/build || $(echo 'failed to create directory' && exit 1)
fi

cd $ROOT/build || $(echo 'failed to change directory' && exit 1)

for TOOL in $TOOLS; do
  if [ ! -e $SRC/llvm/tools/$TOOL ]; then
    ln -s $SRC/$TOOL $SRC/llvm/tools/$TOOL
  fi
done

for PRJ in $PROJECTS; do
  if [ ! -e $SRC/llvm/projects/$PRJ ]; then
    ln -s $SRC/$PRJ $SRC/llvm/projects/$PRJ
  fi
done

if [ ! -d $ROOT/build/llvm ]; then
  mkdir $ROOT/build/llvm || $(echo 'failed to create directory' && exit 1)
fi

cd $ROOT/build/llvm || $(echo 'failed to change directory' && exit 1)

ninja install || exit 42

cd /opt/"$ARCH"-pc-linux-musl/bin || $(echo 'failed to change directory' && exit 1)
ln -s llvm-ar ar
ln -s llvm-ranlib ranlib
ln -s llvm-objcopy objcopy
ln -s llvm-objcopy strip
ln -s llvm-objdump objdump
ln -s llvm-nm nm
ln -s clang cc
ln -s clang++ c++
ln -s ld.lld ld
cd /opt || $(echo 'failed to change directory' && exit 1)
tar cvfz "$ARCH"-pc-linux-musl.tar.gz "$ARCH"-pc-linux-musl || exit 46
