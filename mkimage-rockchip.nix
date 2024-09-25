{ stdenv
, lib
, bc
, bison
, fetchFromGitHub
, flex
, installShellFiles
, ncurses
, openssl
, swig
, buildPackages
}:
let
  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "u-boot";
    rev = "63c55618fbdc36333db4cf12f7d6a28f0a178017";
    hash = "sha256-OZmR6BLwCMK6lq9qmetIdrjSJJWcx7Po1OE9dBWL+Ew=";
  };
  installDir = "$out/bin";
  filesToInstall = ["tools/mkimage"];
in
stdenv.mkDerivation {
  inherit src;
  pname = "uboot-rockchip-mkimage";
  version = "1";
  defconfig = "tools-only_defconfig";
  crossTools = true;
  extraMakeFlags = [ "HOST_TOOLS_ALL=y" "NO_SDL=1" "cross_tools" ];
  outputs = ["out"];
  filesToInstall = ["tools/mkimage"];
    nativeBuildInputs = [
      ncurses
      bc
      bison
      flex
      installShellFiles
      swig
      openssl
    ];
    depsBuildBuild = [ buildPackages.stdenv.cc ];

    hardeningDisable = [ "all" ];

    enableParallelBuilding = true;

    makeFlags = [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
      "NO_SDL=1"
      "tools"
    ];

    passAsFile = [ "extraConfig" ];

    configurePhase = ''
      runHook preConfigure

      make allnoconfig

      runHook postConfigure
    '';

    installPhase = ''
      mkdir -p ${installDir}
      cp ${lib.concatStringsSep " " filesToInstall} ${installDir}
    '';

    dontStrip = true;

    meta = with lib; {
      homepage = "https://www.denx.de/wiki/U-Boot/";
      description = "Boot loader for embedded systems";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ bartsch dezgeg lopsided98 ];
    };
}
