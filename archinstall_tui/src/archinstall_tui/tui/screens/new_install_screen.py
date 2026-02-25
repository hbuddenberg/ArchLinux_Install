from textual.app import ComposeResult
from textual.containers import Center, Vertical
from textual.screen import Screen
from textual.widgets import Button, Footer, Header, Static

from archinstall_tui.core.i18n import t


class NewInstallScreen(Screen):
    """Pantalla de opciones de nueva instalación."""

    BINDINGS = [
        ("q", "quit", "Quit"),
        ("escape", "go_back", "Back"),
        ("up", "focus_previous", "Up"),
        ("down", "focus_next", "Down"),
    ]

    CSS_PATH = "../styles.tcss"

    def compose(self) -> ComposeResult:
        yield Header()

        with Center(), Vertical(id="menu-container"):
            yield Static(t("new_install.title"), id="menu-prompt")

            with Vertical(id="menu-buttons"):
                yield Button(
                    t("new_install.datetime"), id="btn-datetime", variant="default"
                )
                yield Button(
                    t("new_install.pacman"), id="btn-pacman", variant="default"
                )
                yield Button(
                    t("new_install.partitions"), id="btn-partitions", variant="default"
                )
                yield Button(t("new_install.arch"), id="btn-arch", variant="default")
                yield Button(
                    t("new_install.archinstall"),
                    id="btn-archinstall",
                    variant="default",
                )
                yield Button(
                    t("new_install.post_install"),
                    id="btn-post-install",
                    variant="default",
                )
                yield Button(
                    t("new_install.wizard"), id="btn-wizard", variant="primary"
                )
                yield Button(t("menu.exit"), id="btn-back", variant="warning")

        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        btn_id = event.button.id

        # Map button IDs to module subcommands
        action_map = {
            "btn-datetime": "datetime",
            "btn-pacman": "pacman",
            "btn-partitions": "partitions",
            "btn-arch": "arch",
            "btn-archinstall": "archinstall",
            "btn-post-install": "post_install",
            "btn-wizard": "wizard",
        }

        if btn_id == "btn-back":
            self.app.pop_screen()
        elif btn_id in action_map:
            self.app.run_module("new_install", action_map[btn_id])

    def action_go_back(self) -> None:
        self.app.pop_screen()
