# syntax=docker/dockerfile:1.2

# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

FROM docker.io/library/golang:1.20.2-alpine3.16@sha256:50e46c122d9b4e9502be0678b52a807be98f54d3fcab417df986bbc4d210dbf7 as builder
WORKDIR /go/src/github.com/cilium/cilium-cli
RUN apk add --no-cache git make
COPY . .
RUN make

FROM docker.io/library/busybox:stable-glibc@sha256:5289a46d39034cfc035cb32a5f1f890f10da8a13557d7a2df2250d694875d6b4
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder /go/src/github.com/cilium/cilium-cli/cilium /usr/local/bin/cilium
RUN ["wget", "-P", "/usr/local/bin", "https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl"]
RUN ["chmod", "+x", "/usr/local/bin/kubectl"]
ENTRYPOINT []
