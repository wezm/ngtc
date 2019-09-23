# This is a BSD makefile.
# http://www.crufty.net/help/sjg/bmake.html

PODMAN?=podman
LLVM_VERSION?=9.0.0
IMAGE?=wezm-ngtc

all: Dockerfile out
	$(PODMAN) run -v ${.CURDIR}:/ngtc -v ${.CURDIR}/out:/opt --workdir /ngtc $(IMAGE):$(LLVM_VERSION) /bin/sh -c 'root/patch.sh $(LLVM_VERSION) && root/configure.sh && root/build.sh && root/install.sh'

out:
	mkdir out
