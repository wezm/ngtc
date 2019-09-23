FROM wezm-alpine:3.10.2

ARG LLVM_VERSION=9.0.0

RUN apk add --no-cache -t .llvmdeps \
	clang-dev \
	clang-static \
	cmake \
	curl \
	g++ \
	libexecinfo-dev \
	linux-headers \
	make \
	ninja \
	patch \
	python

# Fetch sources
RUN curl \
    -OL http://releases.llvm.org/${LLVM_VERSION}/cfe-${LLVM_VERSION}.src.tar.xz \
    -OL http://releases.llvm.org/${LLVM_VERSION}/cfe-${LLVM_VERSION}.src.tar.xz.sig \
    -OL http://releases.llvm.org/${LLVM_VERSION}/compiler-rt-${LLVM_VERSION}.src.tar.xz \
    -OL http://releases.llvm.org/${LLVM_VERSION}/compiler-rt-${LLVM_VERSION}.src.tar.xz.sig \
    -OL http://releases.llvm.org/${LLVM_VERSION}/libcxx-${LLVM_VERSION}.src.tar.xz \
    -OL http://releases.llvm.org/${LLVM_VERSION}/libcxx-${LLVM_VERSION}.src.tar.xz.sig \
    -OL http://releases.llvm.org/${LLVM_VERSION}/libcxxabi-${LLVM_VERSION}.src.tar.xz \
    -OL http://releases.llvm.org/${LLVM_VERSION}/libcxxabi-${LLVM_VERSION}.src.tar.xz.sig \
    -OL http://releases.llvm.org/${LLVM_VERSION}/libunwind-${LLVM_VERSION}.src.tar.xz \
    -OL http://releases.llvm.org/${LLVM_VERSION}/libunwind-${LLVM_VERSION}.src.tar.xz.sig \
    -OL http://releases.llvm.org/${LLVM_VERSION}/lld-${LLVM_VERSION}.src.tar.xz \
    -OL http://releases.llvm.org/${LLVM_VERSION}/lld-${LLVM_VERSION}.src.tar.xz.sig \
    -OL http://releases.llvm.org/${LLVM_VERSION}/llvm-${LLVM_VERSION}.src.tar.xz \
    -OL http://releases.llvm.org/${LLVM_VERSION}/llvm-${LLVM_VERSION}.src.tar.xz.sig \
    && mkdir /src

# Verify

# Extract
RUN cd /src && \
    tar -Jxf /cfe-${LLVM_VERSION}.src.tar.xz && \
    mv cfe-${LLVM_VERSION}.src clang && \
    tar -Jxf /compiler-rt-${LLVM_VERSION}.src.tar.xz && \
    mv compiler-rt-${LLVM_VERSION}.src compiler-rt && \
    tar -Jxf /libcxx-${LLVM_VERSION}.src.tar.xz && \
    mv libcxx-${LLVM_VERSION}.src libcxx && \
    tar -Jxf /libcxxabi-${LLVM_VERSION}.src.tar.xz && \
    mv libcxxabi-${LLVM_VERSION}.src libcxxabi && \
    tar -Jxf /libunwind-${LLVM_VERSION}.src.tar.xz && \
    mv libunwind-${LLVM_VERSION}.src libunwind && \
    tar -Jxf /lld-${LLVM_VERSION}.src.tar.xz && \
    mv lld-${LLVM_VERSION}.src lld && \
    tar -Jxf /llvm-${LLVM_VERSION}.src.tar.xz && \
    mv llvm-${LLVM_VERSION}.src llvm

