from os import environ
from sys import platform
from platform import machine
from hatchling.builders.hooks.plugin.interface import BuildHookInterface

class CustomHook(BuildHookInterface):
    def initialize(self, version, build_data):
        build_data['pure_python'] = False
        arch = environ.get("AUDITWHEEL_ARCH", machine())
        if "darwin" in platform:
            if "arm" in arch:
                build_data['tag'] = "py3-none-macosx_11_0_arm64"
            else:
                build_data['tag'] = "py3-none-macosx_11_0_x86_64"
        elif "linux" in platform:
            if "arm" in arch or "aarch" in arch:
                build_data['tag'] = "py3-none-linux_aarch64"
            else:
                build_data['tag'] = 'py3-none-linux_x86_64'
        else:
            build_data['tag'] = "py3-none-win_amd64"
