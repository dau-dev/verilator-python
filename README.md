# verilator

Python wrapping/binding for verilator

[![Build Status](https://github.com/dau-dev/verilator-python/actions/workflows/build.yml/badge.svg?branch=main&event=push)](https://github.com/dau-dev/verilator-python/actions/workflows/build.yml)
[![codecov](https://codecov.io/gh/dau-dev/verilator-python/branch/main/graph/badge.svg)](https://codecov.io/gh/dau-dev/verilator-python)
[![License](https://img.shields.io/github/license/dau-dev/verilator-python)](https://github.com/dau-dev/verilator-python)
[![PyPI](https://img.shields.io/pypi/v/verilator.svg)](https://pypi.python.org/pypi/verilator)

## Overview

Wrapper of [verilator](https://github.com/verilator/verilator), distributed via pypi. Includes some extra conveniences.

```bash
verilator-cli run -- *.sv --timing --trace --assert --cc --top-module top --build -j 0
```
