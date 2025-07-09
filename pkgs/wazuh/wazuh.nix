{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  curl,
  autoconf,
  automake,
  cmake,
  libgcc,
  libtool,
  openssl,
  patch,
  perl,
  policycoreutils,
  python312,
  zstd,
  ...
}: let
  ossec = "/var/ossec";
  dependencyVersion = "30";
  fetcher = {
    name,
    sha256,
  }:
    fetchurl {
      url = "https://packages.wazuh.com/deps/${dependencyVersion}/libraries/sources/${name}.tar.gz";
      inherit sha256;
    };
  dependencies = [
    (fetcher
      {
        name = "cJSON";
        sha256 = "678d796318da57d5f38075e74bbb3b77375dc3f8bb49da341ad1b43c417e8cc1";
      })
    (fetcher
      {
        name = "curl";
        sha256 = "sha256-QBUdS8paLByEDtIkNx/g2VFSMXalvDxNA2Lz2m+WZUA=";
      })
    (fetcher
      {
        name = "libdb";
        sha256 = "sha256-fpxE6Mf9sYb/UhqNCFsb+mNNNC3Md37Oofv5qYq13F4=";
      })
    (fetcher
      {
        name = "libffi";
        sha256 = "sha256-DpcfZLrMIglOifA0u6B1tA7MLCwpAO7NeuhYFf1sn2k=";
      })
    (fetcher
      {
        name = "libyaml";
        sha256 = "sha256-NdqtYIs3LVzgmfc4wPIb/MA9aSDZL0SDhsWE5mTxN2o=";
      })
    (fetcher
      {
        name = "openssl";
        sha256 = "sha256-I4QVZBEgyPednBwsr5e4jT1tvtVihZ3QZjvUto3CF54=";
      })
    (fetcher
      {
        name = "procps";
        sha256 = "sha256-Ih85XinRvb5LrMnbOWAu7guuaFqTVDe+DX/rQuMZLQc=";
      })
    (fetcher
      {
        name = "sqlite";
        sha256 = "sha256-mo+mqRb4whB+1l2rjc7TkmBOF1EE1qjDycE4NHmGnwc=";
      })
    (fetcher
      {
        name = "zlib";
        sha256 = "sha256-tZ04FJ8MKexU0nZmEevFpRoDK/lxfjmprwD7bLhTK4s=";
      })
    (fetcher
      {
        name = "audit-userspace";
        sha256 = "sha256-6Coy5e35OwVRYOFLyX9B3q05KHklhR3ICnY44tTTBDQ=";
      })
    (fetcher
      {
        name = "msgpack";
        sha256 = "sha256-BtY7zzKJbNCvVIDEARNLGtHBZv2E6+W0hueSEB7oVOI=";
      })
    (fetcher
      {
        name = "bzip2";
        sha256 = "sha256-J2iO4DFqZLOeURssIkBwytl8OUpfcR+dBV/BgJ2JW80=";
      })
    (fetcher
      {
        name = "nlohmann";
        sha256 = "sha256-zvsHk209W/3T78Xpu408gH1oEnO9rC6Ds9Z67y0RWMQ=";
      })
    (fetcher
      {
        name = "googletest";
        sha256 = "sha256-jB6KCn8iHCEl6Z5qy3CdorpHJHa00FfFjeUEvr841Bc=";
      })
    (fetcher
      {
        name = "libpcre2";
        sha256 = "sha256-WoDWVNfRSz25+jpJ179EpJhoO0Z4SojOxRSosZR2e5I=";
      })
    (fetcher
      {
        name = "libplist";
        sha256 = "sha256-iCeNS9/BvWo6GlWk89kzaD0nMroJz3p0n+jsjuxAbjw=";
      })
    (fetcher
      {
        name = "pacman";
        sha256 = "sha256-9n3Tiir7NA19YDUNSbdamDp8TgGtdgIFaSDv6EnVsUM=";
      })
    (fetcher
      {
        name = "libarchive";
        sha256 = "sha256-yVgEgXXa1aE9CFHQPHwaNjYeEujpPnQywYROlUnd9Yo=";
      })
    (fetcher
      {
        name = "popt";
        sha256 = "sha256-1ogKBmIsoy3EqjmtXc977y+qgb2TGvvmS6Q0rY/uHao=";
      })
    (fetcher
      {
        name = "rpm";
        sha256 = "sha256-rvwlMB7M8irFHL2BOn89RHHxxCYYFy7lSKKbGVmsW68=";
      })
    (fetcher
      {
        name = "rocksdb";
        sha256 = "sha256-7u1go9Tin3MF55+fXOvUJhF0JhIn8bWn0F2lVWVnVDY=";
      })
    (fetcher
      {
        name = "lzma";
        sha256 = "sha256-TODBktQQcrVnmvibtTHvtoXIJnpLfiAFmZFJrBcCgTQ=";
      })
    (fetcher
      {
        name = "cpp-httplib";
        sha256 = "sha256-ZRdXMmNhFoa5IZunlsNfVKMG6yfcPHLhgH8qCjTKweg=";
      })
    (fetcher
      {
        name = "benchmark";
        sha256 = "sha256-lMV6oMsr142+nnfTMsvGRNrw/s3JoJYyBIvm4J+c7Ws=";
      })
    (fetcher
      {
        name = "lua";
        sha256 = "sha256-Yu634kskbFBwi81Nkts8nejRltlMnDO4v/QA8l8QWh8=";
      })
    (fetcher
      {
        name = "cpython";
        sha256 = "sha256-wDZPE1+nKM5bG75ht35mV0PvQ7yYTy7hbW5+QumacHY=";
      })
    (fetcher
      {
        name = "jemalloc";
        sha256 = "sha256-KyLoWzUsffVQukCKQiUeUejf+myRqi4ftIBKsxf/vKA=";
      })
    (fetcher
      {
        name = "flatbuffers";
        sha256 = "sha256-lDaZof6GwZc3HNIUxMNV2g8lOjCT8Mc/t0y0xIuJeKk=";
      })
  ];
  wazuh-http-request = fetchFromGitHub {
    owner = "wazuh";
    repo = "wazuh-http-request";
    rev = "8a302e514de6ef4df86717027682922f705330f4";
    hash = "sha256-lXi/2qQV3v3mikR2SxK0DMpTuw8Dqka5SccA0xMnP0s=";
  };
in
  stdenv.mkDerivation rec {
    pname = "wazuh-agent";
    version = "4.9.1";

    meta = {
      description = "Wazuh agent for NixOS";
      homepage = "https://wazuh.com";
    };

    src = fetchFromGitHub {
      owner = "wazuh";
      repo = "wazuh";
      rev = "v${version}";
      sha256 = "sha256-OiNwKX/bGjh9e7EQ/8ylY2SSjifqu9vfpne9mvHvEmM=";
    };

    enableParallelBuilding = true;
    dontConfigure = true;
    dontFixup = true;

    buildInputs = [
      curl
      autoconf
      automake
      cmake
      stdenv.cc.libcxx
      stdenv.cc.coreutils_bin
      libtool
      openssl
      perl
      policycoreutils
      python312
      zstd
    ];

    makeFlags = [
      "-C src"
      "TARGET=agent"
      "INSTALLDIR=$out"
    ];

    unpackPhase = ''
      runHook preUnpack

      cp -rf --no-preserve=all "$src"/* .

      mkdir -p src/external
      ${lib.strings.concatMapStringsSep "\n" (dep: "tar -xzf ${dep} -C src/external") dependencies}

      cp --no-preserve=all -rf ${wazuh-http-request}/* src/shared_modules/http-request/

      runHook postUnpack
    '';

    patchPhase = ''
      runHook prePatch

      ${patch}/bin/patch -p1 < ${./makefile-patch-1.patch}

      substituteInPlace src/init/wazuh-server.sh \
        --replace-fail "cd ''${LOCAL}" ""

      substituteInPlace src/external/audit-userspace/autogen.sh \
        --replace-warn "cp INSTALL.tmp INSTALL" ""

      substituteInPlace src/external/openssl/config \
        --replace-warn "/usr/bin/env" "env"

      touch src/external/cpython.tar

      cat << EOF > "etc/preloaded-vars.conf"
      USER_LANGUAGE="en"
      USER_NO_STOP="y"
      USER_INSTALL_TYPE="agent"
      USER_DIR="$out"
      USER_DELETE_DIR="n"
      USER_ENABLE_ACTIVE_RESPONSE="y"
      USER_ENABLE_SYSCHECK="y"
      USER_ENABLE_ROOTCHECK="y"
      USER_ENABLE_OPENSCAP="y"
      USER_ENABLE_SYSCOLLECTOR="y"
      USER_ENABLE_SECURITY_CONFIGURATION_ASSESSMENT="y"
      USER_AGENT_SERVER_IP=127.0.0.1
      USER_CA_STORE="no"
      EOF

      # ln -sf ${libgcc.lib}/lib/libgcc_s.so.1 src/libgcc_s.so.1
      # ln -sf ${libgcc.lib}/lib/libstdc++.so.6 src/libstdc++.so.6

      runHook postPatch
    '';

    preBuild = ''
      make -C src TARGET=agent INSTALLDIR=$out deps
    '';

    installPhase = ''
      mkdir -p $out/{bin,etc/shared,queue,var,wodles,logs,lib,tmp,agentless.active-response}

      substituteInPlace install.sh \
        --replace-warn "Xroot" "Xnixbld"
      chmod u+x install.sh

      substituteInPlace src/init/inst-functions.sh \
        --replace-warn "WAZUH_GROUP='wazuh'" "WAZUH_GROUP='nixbld'" \
        --replace-warn "WAZUH_USER='wazuh'" "WAZUH_USER='nixbld'"

      INSTALLDIR=$out USER_DIR=$out ./install.sh binary-install

      substituteInPlace $out/bin/wazuh-control \
        --replace-fail "cd ''${LOCAL}" "#"

      chmod u+x $out/bin/* $out/active-response/bin/*
      rm -rf $out/src
    '';
  }
