{ tunnel, tunnelc4, ospf, ... }:
let
  #defaultPubKey = "xKFL+lNkneISEEIVzOAUATtQgWQT88kGczWQoxun4H0="; # No really used in the config but keeping it to find it easily
  #defaultPrivKey = "KL5dnVroQHh5zFm9OUcupwdr9wkNAcPkd33xNrWPgEI=";
in
{
  #wgde02gload = tunnelc4 25505 defaultPrivKey "B1xSG/XTJRLd+GrWDsB06BqnIq8Xud93YVh/LYYYtUY=" "de2.g-load.eu:21436" "wgde02gload" "172.20.53.97" "fe80::ade0" "192.168.217.77/32";
}