{ ... }:
{
  sessions = [
    {
      multi = true; # BGP Multi-Protocol
      name = "de02gload";
      neigh = "fe80::ade0%wgde02gload";
      as = "4242423914";
      link = "3";
    }
  ];

  extraConfig = '''';
}
