from archinstall_tui.core.i18n import t
from archinstall_tui.modules.base import Module, ModuleInfo, ModuleResult


class NewInstallModule(Module):
    @property
    def info(self) -> ModuleInfo:
        return ModuleInfo(
            id="new_install",
            name=t("menu.new_install"),
            description=t("new_install.title"),
            icon="📦",
        )

    def run(self, subcommand: str = "wizard", *args, **kwargs) -> ModuleResult:
        from pathlib import Path

        from archinstall_tui.services.bash_runner import BashRunner

        script_map = {
            "datetime": "date_time_zone/main.sh",
            "pacman": "pacman_update/main.sh",
            "partitions": "partitions/main.sh",
            "arch": "install_arch/main.sh",
            "archinstall": "install_by_archinstall/main.sh",
            "post_install": "post_install/main.sh",
            "wizard": None,
        }

        if subcommand not in script_map:
            return ModuleResult(
                success=False,
                message=f"Unknown subcommand: {subcommand}",
            )

        if subcommand == "wizard":
            return ModuleResult(
                success=True,
                message="Wizard mode - coming soon",
                data={"mode": "wizard"},
            )

        script_path = (
            Path("/workspace/src/modules/new_install") / script_map[subcommand]
        )

        if not script_path.exists():
            return ModuleResult(
                success=False,
                message=f"Script not found: {script_path}",
            )

        runner = BashRunner()
        result = runner.execute(script_path)

        return ModuleResult(
            success=result.success,
            message=result.output
            if result.success
            else (result.error or "Unknown error"),
            data={"exit_code": result.exit_code},
        )
