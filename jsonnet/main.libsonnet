// https://gitlab.com/cocainefarm/k8s/lib/util

local util(k) = {
  ingressFor(targetService, domain, tlsSecretName)::
    local ingress = k.networking.v1.ingress,
          ingressRule = k.networking.v1.ingressRule,
          ingressTLS = k.networking.v1.ingressTLS,
          httpIngressPath = k.networking.v1.httpIngressPath,
          service = k.core.v1.service;

    ingress.new(targetService.metadata.name) +
    ingress.mixin.spec.withRules(
      ingressRule.withHost(domain) +
      ingressRule.mixin.http.withPaths(
        httpIngressPath.withPath('/') +
        httpIngressPath.withPathType('Prefix') +
        httpIngressPath.backend.service.withName(targetService.metadata.name) +
        httpIngressPath.backend.service.port.withName(targetService.spec.ports[0].name)
      )
    ) +
    ingress.mixin.spec.withTls(
      ingressTLS.withHosts(domain) +
      ingressTLS.withSecretName(tlsSecretName)
    ),
};

util((import 'k.libsonnet'))
