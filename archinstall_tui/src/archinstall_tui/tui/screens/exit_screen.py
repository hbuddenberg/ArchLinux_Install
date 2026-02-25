from textual.app import ComposeResult
from textual.containers import Center, Vertical
from textual.screen import Screen
from textual.widgets import Button, Footer, Header, Static

from archinstall_tui.core.i18n import t


class ExitScreen(Screen):
    """Pantalla de confirmación de salida."""

    BINDINGS = [
        ("q", "quit_app", "Quit"),
        ("escape", "go_back", "Back"),
    ]

    CSS_PATH = "../styles.tcss"

    def compose(self) -> ComposeResult:
        yield Header()

        with Center(), Vertical(id="menu-container"):
            yield Static(t("exit.confirm"), id="menu-prompt")

            with Vertical(id="menu-buttons"):
                yield Button(t("exit.yes"), id="btn-exit-yes", variant="error")
                yield Button(t("exit.no"), id="btn-exit-no", variant="primary")

        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        btn_id = event.button.id

        if btn_id == "btn-exit-yes":
            self.app.exit()
        elif btn_id == "btn-exit-no":
            self.app.pop_screen()

    def action_go_back(self) -> None:
        self.app.pop_screen()

    def action_quit_app(self) -> None:
        """Cerrar la aplicación."""
        self.app.exit()
