from os import listdir
from pathlib import Path
from shutil import which
from subprocess import check_call


class TestEndToEnd:
    def test_basic(self):
        print(which("verilator-cli"))
        check_call(
            [
                "verilator-cli",
                "--help",
            ],
        )
        check_call(
            [
                "verilator-cli",
                "build",
                "--help",
            ],
        )

    def test_ff(self):
        root = Path("verilator/tests/module/")
        check_call(
            [
                "verilator-cli",
                "build",
                *[str((root / path).as_posix()).replace("\\", "/") for path in listdir(str(root)) if path.endswith(".sv")],
                "--includes",
                str(root.as_posix()),
                "--top-module",
                "ff_top",
                "--exe",
                "ff_sim_sv.cpp",
                "--output",
                str(root.as_posix()),
            ],
        )

        check_call([str(Path("verilator/tests/module/Vff_top").resolve())])
