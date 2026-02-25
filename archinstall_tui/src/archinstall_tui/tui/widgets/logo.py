from pathlib import Path

from textual.widgets import Static


class ArchLogo(Static):
    """Arch Linux logo widget - displays centered logo with background."""

    DEFAULT_CSS = """
    ArchLogo {
        padding: 1 0;
        margin-bottom: 1;
    }
    """

    def __init__(self, logo_path: Path | None = None, **kwargs):
        # Set logo_path before calling super().__init__
        self.logo_path = (
            logo_path or Path(__file__).parent.parent.parent / "assets" / "logo.txt"
        )
        # Pass content directly to Static constructor with markup enabled
        super().__init__(self._load_logo(), markup=True, **kwargs)

    def _load_logo(self) -> str:
        """Load colored logo content using Rich markup."""
        if self.logo_path and self.logo_path.exists():
            with open(self.logo_path, encoding="utf-8") as f:
                #lines = [line.rstrip("\n") for line in f.readlines()]
                lines = [line.rstrip("\n") for line in f.readlines()]

            result = []
            for i, line in enumerate(lines):
                # Text appears on lines 8-11 (1-indexed, so 7-10 in 0-indexed)
                if 7 <= i < 11:
                    # Split mountain part (left) from text part (right)
                    # Mountains are on the left, text is on the right
                    text_start = line.find("|")
                    if text_start > 0:
                        mountain = line[:text_start]
                        text_part = line[text_start:]
                        result.append(
                            f"[cyan]{mountain}[/cyan][white]{text_part}[/white]"
                        )
                    else:
                        result.append(f"[cyan]{line}[/cyan]")
                else:
                    # Lines 0-7, 11-18: cyan mountains only
                    result.append(f"[cyan]{line}[/cyan]")
            return "\n".join(result)
        return self._fallback_logo()

    def _fallback_logo(self) -> str:
        return """
   /\
  /  \
 /    \
/      \
--------
  ARCH
"""

    def on_mount(self) -> None:
        self.add_class("logo-loaded")
