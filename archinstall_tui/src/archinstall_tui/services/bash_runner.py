import os
import shutil
import subprocess
from pathlib import Path

from archinstall_tui.services.base import Service, ServiceResult


class BashRunner(Service):
    def __init__(self, timeout: int = 3600):
        self.timeout = timeout

    def execute(
        self,
        script: str | Path,
        args: list[str] | None = None,
        cwd: Path | None = None,
        env: dict[str, str] | None = None,
    ) -> ServiceResult:
        script_path = Path(script)

        if not script_path.exists():
            return ServiceResult(
                success=False,
                output="",
                error=f"Script not found: {script_path}",
                exit_code=127,
            )

        bash_path = shutil.which("bash")
        if not bash_path:
            return ServiceResult(
                success=False,
                output="",
                error="Bash not found in PATH",
                exit_code=127,
            )

        cmd = [bash_path, str(script_path)]
        if args:
            cmd.extend(args)

        run_env = None
        if env:
            run_env = dict(os.environ)
            run_env.update(env)

        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=self.timeout,
                cwd=cwd,
                env=run_env,
            )

            return ServiceResult(
                success=result.returncode == 0,
                output=result.stdout,
                error=result.stderr if result.stderr else None,
                exit_code=result.returncode,
            )

        except subprocess.TimeoutExpired:
            return ServiceResult(
                success=False,
                output="",
                error=f"Timeout after {self.timeout} seconds",
                exit_code=124,
            )

        except Exception as e:
            return ServiceResult(
                success=False,
                output="",
                error=str(e),
                exit_code=1,
            )

    def run_inline(self, command: str, cwd: Path | None = None) -> ServiceResult:
        bash_path = shutil.which("bash")
        if not bash_path:
            return ServiceResult(
                success=False,
                output="",
                error="Bash not found in PATH",
                exit_code=127,
            )

        try:
            result = subprocess.run(
                [bash_path, "-c", command],
                capture_output=True,
                text=True,
                timeout=self.timeout,
                cwd=cwd,
            )

            return ServiceResult(
                success=result.returncode == 0,
                output=result.stdout,
                error=result.stderr if result.stderr else None,
                exit_code=result.returncode,
            )

        except subprocess.TimeoutExpired:
            return ServiceResult(
                success=False,
                output="",
                error=f"Timeout after {self.timeout} seconds",
                exit_code=124,
            )

        except Exception as e:
            return ServiceResult(
                success=False,
                output="",
                error=str(e),
                exit_code=1,
            )
