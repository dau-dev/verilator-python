from os import environ
from pathlib import Path
from subprocess import Popen
from sys import stderr, stdout
from time import sleep

from typer import Context, Exit, Typer


def verilator(ctx: Context):
    verilator_root = Path(__file__).parent.resolve()
    environ["VERILATOR_ROOT"] = str(verilator_root)
    environ["CXXFLAGS"] = environ.get("CXXFLAGS", "--std=c++20")
    build_cmd = [
        str((verilator_root / "bin" / "verilator").resolve()),
        *ctx.args,
    ]

    process = Popen(build_cmd, stderr=stderr, stdout=stdout)
    while process.poll() is None:
        sleep(0.1)
    if process.returncode != 0:
        raise Exit(process.returncode)


def build(): ...


def main():
    app = Typer()
    app.command(
        "run",
        context_settings={"allow_extra_args": True},
    )(verilator)
    app.command("build")(build)
    app()


if __name__ == "__main__":
    main()
