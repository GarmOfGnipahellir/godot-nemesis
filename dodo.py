import re
import subprocess
import os
import zipfile


def get_version():
    """Returns the project verison from project.godot"""

    version = "none"
    with open("project.godot", "r") as fp:
        for line in fp.readlines():
            if "config/version" in line:
                version = re.search(r"(\d+.\d+.\d+)", line).group(0)
    return version


def task_build():
    """Builds the win64 executable"""

    if not os.path.exists("builds/win64"):
        os.makedirs("builds/win64")

    return {
        "actions": ["godot --export win64 builds/win64/Nemesis.exe"],
    }


def task_prepare_deploy():
    """
    Creates a zip archive with the of the latest build.  
    WARNING: Will be named using the current project version.
    """

    target = f"builds/godot-nemesis_{get_version()}_win64.zip"

    def make_zip():
        with zipfile.ZipFile(target, "w") as zf:
            for file in os.listdir("builds/win64"):
                zf.write(f"builds/win64/{file}", file)

    return {
        "actions": [make_zip],
        "task_dep": ["build"]
    }
