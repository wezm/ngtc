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

cmake \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLIBCXXABI_LIBCXX_PATH=$SRC/libcxx \
    -DLIBCXXABI_LIBCXX_INCLUDES=$SRC/libcxx/include \
    -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
    -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
    -DLIBCXX_LIBCXXABI_INCLUDES_INTERNAL=$SRC/libcxxabi/include \
    -DLIBCXX_HAS_MUSL_LIBC=ON \
    -DLIBCXX_HAS_GCC_S_LIB=OFF \
    -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
    -DLIBUNWIND_ENABLE_SHARED=OFF \
    -DCLANG_DEFAULT_CXX_STDLIB=libc++ \
    -DCLANG_DEFAULT_LINKER=lld \
    -DCLANG_DEFAULT_RTLIB=compiler-rt \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$ARCH"-pc-linux-musl \
    -DDEFAULT_SYSROOT=/"$ARCH"-pc-linux-musl \
    -DCMAKE_INSTALL_PREFIX=/opt/"$ARCH"-pc-linux-musl \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGET_ARCH="$ARCH" \
    -DLLVM_TARGETS_TO_BUILD="$TARGETS" \
    -G Ninja \
    $SRC/llvm || exit 40
