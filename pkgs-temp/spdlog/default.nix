{gcc8Stdenv, stdenv, fetchFromGitHub, cmake, gbenchmark }:

let
  generic = { version, sha256 }:
    gcc8Stdenv.mkDerivation {
      name = "spdlog-${version}";
      inherit version;

      src = fetchFromGitHub {
        owner  = "gabime";
        repo   = "spdlog";
        rev    = "v${version}";
        inherit sha256;
      };

      nativeBuildInputs = [ cmake ];
      buildInputs = [ gbenchmark ];

      cmakeFlags = [ "-DSPDLOG_BUILD_EXAMPLES=OFF" ];

      outputs = [ "out" "doc" ];

      patches = [
        ./0001-disable-cpuinfo.patch
      ];

      postInstall = ''
        mkdir -p $out/share/doc/spdlog
        cp -rv ../example $out/share/doc/spdlog
      '';

      meta = with stdenv.lib; {
        description    = "Very fast, header only, C++ logging library.";
        homepage       = https://github.com/gabime/spdlog;
        license        = licenses.mit;
        maintainers    = with maintainers; [ obadz ];
        platforms      = platforms.all;
      };
    };
in
{
  spdlog_1 = generic {
    version = "1.3.1";
    sha256 = "1rd4zmrlkcdjx0m0wpmjm1g9srj7jak6ai08qkhbn2lsn0niifzd";
  };

  spdlog_0 = generic {
    version = "0.17.0";
    sha256 = "112kfh4fbpm5cvrmgbgz4d8s802db91mhyjpg7cwhlywffnzkwr9";
  };
}
