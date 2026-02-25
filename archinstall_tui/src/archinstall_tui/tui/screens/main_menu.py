from textual.app import ComposeResult
from textual.containers import Center, Vertical
from textual.screen import Screen
from textual.widgets import Button, Footer, Header, Static

from archinstall_tui.core.i18n import t
from archinstall_tui.tui.widgets.logo import ArchLogo


class MainMenuScreen(Screen):
    BINDINGS = [
        ("q", "quit", "Quit"),
        ("up", "focus_previous", "Up"),
        ("down", "focus_next", "Down"),
    ]

    CSS_PATH = "../styles.tcss"

    def compose(self) -> ComposeResult:
        yield Header()

        with Center(), Vertical(id="menu-container"):
            yield ArchLogo()
            yield Static(t("menu.select"), id="menu-prompt")

            with Vertical(id="menu-buttons"):
                yield Button(
                    t("menu.new_install"), id="btn-new-install", variant="primary"
                )
                yield Button(
                    t("menu.utilities"), id="btn-utilities", variant="default"
                )
                yield Button(t("menu.exit"), id="btn-exit", variant="warning")

        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        btn_id = event.button.id

        if btn_id == "btn-new-install":
            self.app.push_module("new_install")
        elif btn_id == "btn-utilities":
            self.app.push_module("utilities")
        elif btn_id == "btn-exit":
            self.app.request_exit()
