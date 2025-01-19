{ ... }: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "aprl@acab.dev";
  };
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "2g";
  };
}
