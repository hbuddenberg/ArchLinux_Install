from textual.app import ComposeResult
from textual.containers import Center, Vertical
from textual.screen import Screen
from textual.widgets import Button, Footer, Static

from archinstall_tui.core.i18n import t


class UtilitiesScreen(Screen):
    """Pantalla de utilidades."""

    BINDINGS = [
        ("q", "request_exit", "Salir"),
        ("escape", "go_back", "Back"),
        ("up", "focus_previous", "Up"),
        ("down", "focus_next", "Down"),
    ]

    CSS_PATH = "../styles.tcss"

    def compose(self) -> ComposeResult:
        with Center(), Vertical(id="menu-container"):
            yield Static(t("utilities.title"), id="menu-prompt")

            with Vertical(id="menu-buttons"):
                yield Button(
                    t("utilities.hyprland"), id="btn-hyprland", variant="default"
                )
                yield Button(
                    t("utilities.plymouth"), id="btn-plymouth", variant="default"
                )
                yield Button(
                    t("utilities.remmina"), id="btn-remmina", variant="default"
                )
                yield Button(
                    t("utilities.dotfiles"), id="btn-dotfiles", variant="default"
                )
                yield Button(t("menu.exit"), id="btn-back", variant="warning")

        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        btn_id = event.button.id

        # Map button IDs to module subcommands
        action_map = {
            "btn-hyprland": "hyprland",
            "btn-plymouth": "plymouth",
            "btn-remmina": "remmina",
            "btn-dotfiles": "dotfiles",
        }

        if btn_id == "btn-back":
            self.app.pop_screen()
        elif btn_id in action_map:
            self.app.run_module("utilities", action_map[btn_id])

    def action_go_back(self) -> None:
        self.app.pop_screen()

    def action_request_exit(self) -> None:
        """Mostrar pantalla de confirmación de salida."""
        self.app.request_exit()
