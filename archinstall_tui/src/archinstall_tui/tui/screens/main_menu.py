from textual.app import ComposeResult
from textual.containers import Center, Vertical
from textual.screen import Screen
from textual.widgets import Button, Static

from archinstall_tui.core.i18n import t
from archinstall_tui.tui.widgets.logo import ArchLogo


class MainMenuScreen(Screen):
    BINDINGS = [
        ("q", "request_exit", "Salir"),
        ("up", "move_up", "Up"),
        ("down", "move_down", "Down"),
    ]

    CSS_PATH = "../styles.tcss"

    def compose(self) -> ComposeResult:
        with Center(), Vertical(id="menu-container"):
            yield ArchLogo()
            yield Static(t("menu.select"), id="menu-prompt")

            with Vertical(id="menu-buttons"):
                yield Button(
                    t("menu.new_install"), id="btn-new-install", variant="primary"
                )
                yield Button(t("menu.utilities"), id="btn-utilities", variant="default")
                yield Button(t("menu.exit"), id="btn-exit", variant="warning")

        from archinstall_tui.tui.widgets.custom_footer import CustomFooter
        yield CustomFooter()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        btn_id = event.button.id

        if btn_id == "btn-new-install":
            self.app.push_module("new_install")
        elif btn_id == "btn-utilities":
            self.app.push_module("utilities")
        elif btn_id == "btn-exit":
            self.app.request_exit()

    def action_request_exit(self) -> None:
        """Mostrar pantalla de confirmación de salida."""
        self.app.request_exit()
    def action_move_up(self) -> None:
        """Mover el foco al botón anterior."""
        buttons = list(self.query("Button"))
        if not buttons:
            return
        current_focused = self.focused
        if current_focused in buttons:
            current_index = buttons.index(current_focused)
            previous_index = (current_index - 1) % len(buttons)
            buttons[previous_index].focus()
        else:
            buttons[0].focus()

    def action_move_down(self) -> None:
        """Mover el foco al siguiente botón."""
        buttons = list(self.query("Button"))
        if not buttons:
            return
        current_focused = self.focused
        if current_focused in buttons:
            current_index = buttons.index(current_focused)
            next_index = (current_index + 1) % len(buttons)
            buttons[next_index].focus()
        else:
            buttons[0].focus()
