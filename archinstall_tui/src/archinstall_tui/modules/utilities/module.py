from archinstall_tui.core.i18n import t
from archinstall_tui.modules.base import Module, ModuleInfo, ModuleResult


class UtilitiesModule(Module):
    @property
    def info(self) -> ModuleInfo:
        return ModuleInfo(
            id="utilities",
            name=t("menu.utilities"),
            description=t("utilities.title"),
            icon="🔧",
        )

    def run(self, subcommand: str = "menu", *args, **kwargs) -> ModuleResult:
        from pathlib import Path

        from archinstall_tui.services.bash_runner import BashRunner

        script_map = {
            "hyprland": "hyprland/main.sh",
            "plymouth": "plymouth/main.sh",
            "remmina": "remmina/main.sh",
            "dotfiles": "to_dotfiles/main.sh",
        }

        # Caso especial para "menu" - mostrar opciones disponibles
        if subcommand == "menu":
            return ModuleResult(
                success=True,
                message="Available utilities: " + ", ".join(script_map.keys()),
                data={"options": list(script_map.keys())},
            )

        if subcommand not in script_map:
            return ModuleResult(
                success=False,
                message=f"Unknown subcommand: {subcommand}. Available: {', '.join(script_map.keys())}",
            )

        script_path = Path("/workspace/src/modules/utilities") / script_map[subcommand]

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
