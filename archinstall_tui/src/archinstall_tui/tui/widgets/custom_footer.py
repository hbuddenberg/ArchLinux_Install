"""Custom Footer widget with left-aligned bindings and right-aligned Theme/Language."""

from textual.app import ComposeResult
from textual.containers import Horizontal
from textual.widgets import Footer, Static


class CustomFooter(Horizontal):
    """A custom footer with left-aligned bindings and right-aligned Theme/Language.

    Layout:
    ┌──────────────────────────────────────────────────────────────────────────────┐
    │ q Salir  ↑ Up  ↓ Down  esc Back  │  ctrl+t Theme  ctrl+l Language            │
    └──────────────────────────────────────────────────────────────────────────────┘
    """

    DEFAULT_CSS = """
    CustomFooter {
        dock: bottom;
        height: 1;
        layout: horizontal;
        background: $panel;
        padding: 0 1;
    }

    CustomFooter > #bindings {
        width: auto;
    }

    CustomFooter > #spacer {
        width: 1fr;
    }

    CustomFooter > #theme-language {
        width: auto;
        text-style: bold;
        color: $text;
    }
    """

    def compose(self) -> ComposeResult:
        """Compose the footer layout."""
        # Left side: default Footer with all bindings except theme/language
        yield Footer()

        # Spacer to push theme/language to the right
        yield Static("", id="spacer")

        # Right side: Theme and Language bindings
        yield Static("ctrl+t Theme  ctrl+l Language", id="theme-language")
