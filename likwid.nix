{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "likwid";
  version = "5.3.0";
  src = ./.;

  buildInputs = with pkgs; [
    perl
    clang
    gcc
  ];

  enableParallelBuilding = true;

  hardeningDisable = ["format"];

  preBuild = ''
    substituteInPlace config.mk --replace-warn 'PREFIX ?= /usr/local' "PREFIX ?= $out" --replace-warn "ACCESSMODE = accessdaemon" "ACCESSMODE = perf_event"
    substituteInPlace perl/gen_events.pl --replace-warn '/usr/bin/env perl' '${pkgs.perl}/bin/perl'
    substituteInPlace bench/perl/generatePas.pl --replace-warn '/usr/bin/env perl' '${pkgs.perl}/bin/perl'
    substituteInPlace bench/perl/AsmGen.pl --replace-warn '/usr/bin/env perl' '${pkgs.perl}/bin/perl'
    substituteInPlace Makefile --replace-warn '@install -m 4755 $(INSTALL_CHOWN)' '#@install -m 4755 $(INSTALL_CHOWN)'
  '';
}
