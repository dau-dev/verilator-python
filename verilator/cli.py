from functools import lru_cache
from os import environ
from sys import argv
from pathlib import Path
from shutil import which
from subprocess import Popen
from sys import stderr, stdout, exit
from time import sleep
from typing import List


@lru_cache(maxsize=1)
def _get_verilator() -> str:
    verilator_exe = which("verilator")
    if not verilator_exe:
        verilator_root = Path(__file__).parent.resolve()
        verilator_exe = str((verilator_root / "bin" / "verilator").resolve())
        environ["VERILATOR_ROOT"] = str(verilator_root)
        environ["CXXFLAGS"] = environ.get("CXXFLAGS", "--std=c++20")
    return verilator_exe


def verilator(argv):
    build_cmd = [
        _get_verilator(),
        *argv,
    ]
    process = Popen(build_cmd, stderr=stderr, stdout=stdout)
    while process.poll() is None:
        sleep(0.1)
    if process.returncode != 0:
        raise exit(process.returncode)


def build(
    input: List[str],
    output: str = "obj_dir",
    includes: List[str] = None,
    timing: bool = True,
    trace: bool = True,
    assert_: bool = True,
    cc: bool = True,
    build: bool = True,
    exe: str = None,
    top_module: str = None,
):
    """Utility to build a verilated module"""
    includes = includes or []
    args = [
        *input,
        *["-I" + _ for _ in includes],
    ]
    if timing:
        args.append("--timing")
    if trace:
        args.append("--trace")
    if assert_:
        args.append("--assert")
    if cc:
        args.append("--cc")
    if top_module:
        args.extend(["--top-module", top_module])
    if exe:
        args.extend(["--exe", exe])
    if build:
        args.extend(["--build", "-j", "0"])
    args.extend(["--Mdir", output])
    verilator(args)


def binding():
    """Utility to build a python binding of a verilated module"""
    # TODO


def main():
    try:
        from typer import Typer

        app = Typer()
        app.command("binding")(binding)
        app.command("build")(build)
        if len(argv) < 2 or argv[1] not in [_.name for _ in app.registered_commands]:
            return verilator(argv[1:])
        return app()
    except ImportError:
        pass
    return verilator(argv[1:])


if __name__ == "__main__":
    main()
