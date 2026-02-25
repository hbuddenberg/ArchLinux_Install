from textual.app import ComposeResult
from textual.containers import Center, Vertical
from textual.screen import Screen
from textual.widgets import Button, Footer, Static

from archinstall_tui.core.i18n import t


class LanguageScreen(Screen):
    """Language selection screen."""

    BINDINGS = [
        ("escape", "go_back", "Back"),
    ]

    CSS_PATH = "../styles.tcss"

    def compose(self) -> ComposeResult:
        with Center(), Vertical(id="menu-container"):
            yield Static(t("language.title"), id="menu-prompt")

            with Vertical(id="menu-buttons"):
                yield Button(t("language.es"), id="btn-lang-es", variant="default")
                yield Button(t("language.en"), id="btn-lang-en", variant="default")
                yield Button(t("menu.exit"), id="btn-back", variant="warning")
        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        btn_id = event.button.id

        if btn_id == "btn-back":
            self.app.pop_screen()
        elif btn_id == "btn-lang-es":
            self.app.set_language("es")
            self.app.pop_screen()
        elif btn_id == "btn-lang-en":
            self.app.set_language("en")
            self.app.pop_screen()

    def action_go_back(self) -> None:
        self.app.pop_screen()
