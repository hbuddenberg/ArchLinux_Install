
from textual.app import App

from archinstall_tui.core.i18n import t
from archinstall_tui.tui.screens.main_menu import MainMenuScreen
from archinstall_tui.tui.screens.new_install_screen import NewInstallScreen
from archinstall_tui.tui.screens.utilities_screen import UtilitiesScreen
from archinstall_tui.tui.screens.exit_screen import ExitScreen
from archinstall_tui.modules.new_install.module import NewInstallModule
from archinstall_tui.modules.utilities.module import UtilitiesModule


class ArchInstallApp(App):
    CSS_PATH = "styles.tcss"
    SCREENS = {
        "main": MainMenuScreen,
        "new_install": NewInstallScreen,
        "utilities": UtilitiesScreen,
        "exit": ExitScreen,
    }
    BINDINGS = [
        ("q", "quit", "Quit"),
        ("escape", "go_back", "Back"),
    ]

    def __init__(self, lang: str | None = None):
        super().__init__()
        self._lang = lang
        self._modules = {
            "new_install": NewInstallModule(),
            "utilities": UtilitiesModule(),
        }

    def on_mount(self) -> None:
        self.title = t("app.title", self._lang)
        self.push_screen("main")

    def push_module(self, module_id: str) -> None:
        """Navigate to a module screen."""
        if module_id in self.SCREENS:
            self.push_screen(module_id)
        else:
            self.notify(f"Unknown module: {module_id}", title="Error", severity="error")

    def run_module(self, module_id: str, subcommand: str) -> None:
        """Execute a module action and show result."""
        if module_id not in self._modules:
            self.notify(f"Unknown module: {module_id}", title="Error", severity="error")
            return

        module = self._modules[module_id]
        result = module.run(subcommand=subcommand)

        if result.success:
            self.notify(result.message, title="Success", severity="information", timeout=5)
        else:
            self.notify(result.message, title="Error", severity="error", timeout=10)

    def request_exit(self) -> None:
        """Show exit confirmation screen."""
        self.push_screen("exit")

    def action_go_back(self) -> None:
        if len(self.screen_stack) > 1:
            self.pop_screen()
