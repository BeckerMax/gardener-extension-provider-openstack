############# builder
FROM golang:1.15.3 AS builder

WORKDIR /go/src/github.com/gardener/gardener-extension-provider-openstack
COPY . .
RUN make install

############# base
FROM alpine:3.12.1 AS base

############# gardener-extension-provider-openstack
FROM base AS gardener-extension-provider-openstack

COPY charts /charts
COPY --from=builder /go/bin/gardener-extension-provider-openstack /gardener-extension-provider-openstack
ENTRYPOINT ["/gardener-extension-provider-openstack"]

############# gardener-extension-validator-openstack
FROM base AS gardener-extension-validator-openstack

COPY --from=builder /go/bin/gardener-extension-validator-openstack /gardener-extension-validator-openstack
ENTRYPOINT ["/gardener-extension-validator-openstack"]
