{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  numpy,
  cython,
  stdenv,
}:
buildPythonPackage rec {
  pname = "lap";
  version = "0.5.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VwtBTqeubAS9SdDsjNrB3FY0c3dVeE1E43+fZourRP0="; # Replace with actual hash
  };

  # Build dependencies
  nativeBuildInputs = [
    setuptools
    wheel
    cython
  ];

  # Runtime dependencies
  propagatedBuildInputs = [
    numpy
    stdenv.cc.cc.lib
  ];

  # do not run tests as they are not included in the PyPI package
  doCheck = false;

  meta = with lib; {
    description = "Linear Assignment Problem solver (LAPJV/LAPMOD)";
    homepage = "https://github.com/gatagat/lap";
    license = licenses.bsd2;
    maintainers = []; # Add maintainers if desired
  };
}
