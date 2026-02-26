"""Test script to verify Button:focus styling"""

from textual.app import App, ComposeResult
from textual.widgets import Button, Footer
from textual.containers import Vertical


class TestApp(App):
    CSS = """
    Screen {
        align: center middle;
    }
    
    Button {
        min-width: 20;
        padding: 1 2;
        margin: 1;
    }
    
    /* Generic button focus */
    Button:focus {
        background: rgb(23, 147, 209);
        border: thick rgb(23, 147, 209);
        color: black;
    }
    
    Button.primary:focus {
        background: rgb(23, 147, 209) !important;
        border: thick rgb(23, 147, 209) !important;
        color: black !important;
    }
    """

    def compose(self) -> ComposeResult:
        yield Vertical(
            Button("Default Button"),
            Button("Primary Button", variant="primary"),
            Button("Warning Button", variant="warning"),
            Button("Error Button", variant="error"),
        )
        yield Footer()


if __name__ == "__main__":
    app = TestApp()
    app.run()
