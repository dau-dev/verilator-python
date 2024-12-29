from glob import glob
from subprocess import check_call


class TestEndToEnd:
    def test_ff(self):
        check_call(
            [
                "verilator-cli",
                "build",
                *glob("verilator/tests/module/*.sv"),
                "--includes",
                "verilator/tests/module",
                "--top-module",
                "ff_top",
                "--exe",
                "ff_sim_sv.cpp",
                "--output",
                "verilator/tests/module",
            ],
        )

        check_call(["verilator/tests/module/Vff_top"])
