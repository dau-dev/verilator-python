from os import environ
from sys import argv
from pathlib import Path
from shutil import which
from subprocess import Popen
from sys import stderr, stdout, exit
from time import sleep


def verilator(argv):
    verilator_exe = which("verilator")
    if not verilator_exe:
        verilator_root = Path(__file__).parent.resolve()
        verilator_exe = str((verilator_root / "bin" / "verilator").resolve())
        environ["VERILATOR_ROOT"] = str(verilator_root)
        environ["CXXFLAGS"] = environ.get("CXXFLAGS", "--std=c++20")
    build_cmd = [
        verilator_exe,
        *argv,
    ]
    process = Popen(build_cmd, stderr=stderr, stdout=stdout)
    while process.poll() is None:
        sleep(0.1)
    if process.returncode != 0:
        raise exit(process.returncode)


def build(): ...


def test(): ...


def main():
    try:
        from typer import Typer

        app = Typer()
        app.command("build")(build)
        app.command("test")(test)
        if len(argv) < 2 or argv[1] not in [_.name for _ in app.registered_commands]:
            return verilator(argv[1:])
        return app()
    except ImportError:
        pass
    return verilator(argv[1:])


if __name__ == "__main__":
    main()
