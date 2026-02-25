from archinstall_tui.core.i18n import t
from archinstall_tui.modules.base import Module, ModuleInfo, ModuleResult


class ExitModule(Module):
    @property
    def info(self) -> ModuleInfo:
        return ModuleInfo(
            id="exit",
            name=t("menu.exit"),
            description=t("exit.confirm"),
            icon="🚪",
        )

    def run(self, confirm: bool = False, *args, **kwargs) -> ModuleResult:
        if confirm:
            return ModuleResult(
                success=True,
                message="exit_confirmed",
                data={"should_exit": True},
            )

        return ModuleResult(
            success=True,
            message=t("exit.confirm"),
            data={"should_exit": False, "requires_confirmation": True},
        )
