from textual.app import ComposeResult
from textual.containers import Center, Vertical
from textual.screen import Screen
from textual.widgets import Button, Footer, Static

from archinstall_tui.core.i18n import t


class ThemeScreen(Screen):
    """Theme selection screen."""

    BINDINGS = [
        ("escape", "go_back", "Back"),
    ]

    CSS_PATH = "../styles.tcss"

    def compose(self) -> ComposeResult:
        with Center(), Vertical(id="menu-container"):
            yield Static(t("theme.title"), id="menu-prompt")

            with Vertical(id="menu-buttons"):
                yield Button(
                    "textual-dark", id="btn-theme-textual-dark", variant="default"
                )
                yield Button(
                    "textual-light", id="btn-theme-textual-light", variant="default"
                )
                yield Button("nord", id="btn-theme-nord", variant="default")
                yield Button("gruvbox", id="btn-theme-gruvbox", variant="default")
                yield Button(
                    "catppuccin-mocha",
                    id="btn-theme-catppuccin-mocha",
                    variant="default",
                )
                yield Button("dracula", id="btn-theme-dracula", variant="default")
                yield Button(
                    "tokyo-night", id="btn-theme-tokyo-night", variant="default"
                )
                yield Button("monokai", id="btn-theme-monokai", variant="default")
                yield Button(
                    "solarized-dark", id="btn-theme-solarized-dark", variant="default"
                )
                yield Button("rose-pine", id="btn-theme-rose-pine", variant="default")
                yield Button(
                    "atom-one-dark", id="btn-theme-atom-one-dark", variant="default"
                )
                yield Button(t("menu.exit"), id="btn-back", variant="warning")

        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        btn_id = event.button.id

        if btn_id == "btn-back":
            self.app.pop_screen()
        elif btn_id.startswith("btn-theme-"):
            theme_name = btn_id.replace("btn-theme-", "")
            self.app.set_theme(theme_name)
            self.app.pop_screen()

    def action_go_back(self) -> None:
        self.app.pop_screen()
