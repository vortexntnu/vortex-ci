"""Regression checks for the development Compose configuration.

Run from the repository root: python3 -m unittest discover -s docker -p 'test_*.py' -v
Docker Compose is required; these tests do not start containers or require a GPU.
"""

import json
import os
from pathlib import Path
import subprocess
import unittest


ROOT = Path(__file__).resolve().parents[1]


class ComposeTests(unittest.TestCase):
    def config(self, *files, desktop=False):
        env = os.environ.copy()
        env.pop("DISPLAY", None)
        env.pop("XAUTHORITY", None)
        if desktop:
            env.update(DISPLAY=":0", XAUTHORITY="/dev/null")
        command = ["docker", "compose", "--env-file", "/dev/null"]
        for file in files:
            command.extend(["-f", str(ROOT / "docker" / file)])
        result = subprocess.run(
            [*command, "config", "--format", "json"],
            cwd=ROOT,
            env=env,
            capture_output=True,
            text=True,
            check=True,
        )
        return json.loads(result.stdout)["services"]["ros2"]

    def test_image_matches_documented_build(self):
        service = self.config("compose.yaml", desktop=True)
        self.assertEqual(service["image"], "vortex:latest")

    def test_headless_service_needs_no_desktop_or_gpu(self):
        service = self.config("compose.yaml")
        self.assertFalse(service.get("gpus"))
        self.assertFalse(service.get("environment"))
        self.assertEqual(service["working_dir"], "/ros2_ws")
        self.assertEqual(len(service["volumes"]), 1)
        self.assertEqual(service["volumes"][0]["target"], "/ros2_ws/src")

    def test_nvidia_override_preserves_headless_service_and_adds_graphics(self):
        service = self.config("compose.yaml", "compose.nvidia.yaml", desktop=True)
        self.assertEqual(service["image"], "vortex:latest")
        self.assertEqual(service["gpus"][0]["count"], -1)
        self.assertEqual(service["environment"]["DISPLAY"], ":0")
        self.assertEqual(service["environment"]["XAUTHORITY"], "/tmp/host.xauth")
        volumes = {volume["target"]: volume for volume in service["volumes"]}
        self.assertIn("/ros2_ws/src", volumes)
        self.assertTrue(volumes["/tmp/.X11-unix"]["read_only"])
        self.assertTrue(volumes["/tmp/host.xauth"]["read_only"])
        self.assertFalse(volumes["/tmp/host.xauth"]["bind"]["create_host_path"])


if __name__ == "__main__":
    unittest.main()
