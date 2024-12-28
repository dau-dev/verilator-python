# verilator

Python wrapping/binding for verilator

[![Build Status](https://github.com/dau-dev/verilator-python/actions/workflows/build.yml/badge.svg?branch=main&event=push)](https://github.com/dau-dev/verilator-python/actions/workflows/build.yml)
[![codecov](https://codecov.io/gh/dau-dev/verilator-python/branch/main/graph/badge.svg)](https://codecov.io/gh/dau-dev/verilator-python)
[![License](https://img.shields.io/github/license/dau-dev/verilator-python)](https://github.com/dau-dev/verilator-python)
[![PyPI](https://img.shields.io/pypi/v/verilator.svg)](https://pypi.python.org/pypi/verilator)

## Overview

Wrapper of [verilator](https://github.com/verilator/verilator), distributed via pypi. Includes some extra conveniences.

```bash
# Pass-through to verilator
verilator-cli sv/*.sv --timing --trace --assert --cc -Isv --top-module top --build -j 0 --exe sv/sim_sv.cpp

# Wrapper
verilator-cli build sv/*.sv --includes sv --top-module top --exe sv/sim_sv.cpp
```

## License
This software is licensed under the Apache 2.0 license. See the [LICENSE](LICENSE) file for details.

Verilator is Copyright 2003-2024 by Wilson Snyder. Verilator is free software subjectto either the GNU Lesser General Public License Version 3 or the Perl Artistic License Version 2.0.
