
from textual.app import App

from archinstall_tui.core.i18n import t
from archinstall_tui.tui.screens.main_menu import MainMenuScreen


class ArchInstallApp(App):
    CSS_PATH = "styles.tcss"
    SCREENS = {
        "main": MainMenuScreen,
    }
    BINDINGS = [
        ("q", "quit", "Quit"),
        ("escape", "go_back", "Back"),
    ]

    def __init__(self, lang: str | None = None):
        super().__init__()
        self._lang = lang

    def on_mount(self) -> None:
        self.title = t("app.title", self._lang)
        self.push_screen("main")

    def push_module(self, module_id: str) -> None:
        self.notify(f"Module: {module_id}", title="Navigation", severity="information")

    def request_exit(self) -> None:
        self.action_quit()

    def action_go_back(self) -> None:
        if len(self.screen_stack) > 1:
            self.pop_screen()
