{ tunnel, tunnelc4, rip, ripx, ... }:
let
  defaultPubKey = "DB5EDqZbwMFPek+D2MP2gInLayGUcqx2d1Pk3lm2zig="; # No really used in the config but keeping it to find it easily
  defaultPrivKey = "/var/wg-storage/private";
in
{
  #wglucy = rip 25508 defaultPrivKey "tw+J+r8qW0D50gBXfuiyK4qnZPhuliQ4Hd4/9AwE8Hc=" "example.com:21436" "wglucy" "10.20.53.97" "fe80::ade0" "10.20.53.1/24" "fe80::a344/128" false;
  wghomenet = ripx 25509 defaultPrivKey "DYwMrDjH6xAMZKbQMduSa3/xLIypjObaeAByliEXzXU=" "example.com:21436" "wghomenet" "10.20.129.1/24" "fd42:acab:f00d:9999::1/64" "10.20.129.2/24" "fd42:acab:f00d:9999::2/64" false "fe80:acad:1312::1/64" "fe80:acad:1312::2/64";
} 