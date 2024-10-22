{ pkgs, ... }: {
  services.i2pd = {
    enable = true;
    address = "127.0.0.1"; # you may want to set this to 0.0.0.0 if you are planning to use an ssh tunnel
    proto = {
      http.enable = true;
      socksProxy.enable = true;
      httpProxy.enable = true;
      sam.enable = true;
    };
  };
  environment.systemPackages = [
    pkgs.xd
  ]; 
}
