from pathlib import Path

from textual.widgets import Static


class ArchLogo(Static):
    """Arch Linux logo widget - displays logo with image/ASCII fallback support."""

    DEFAULT_CSS = """
    ArchLogo {
        padding: 1 0;
        margin-bottom: 1;
    }
    """

    def __init__(self, logo_path: Path | None = None, **kwargs):
        # Try multiple logo formats in order of preference
        self.assets_dir = Path(__file__).parent.parent.parent / "assets"
        self.custom_path = logo_path  # Store custom path for reference
        self.logo_path = self._find_logo(logo_path)

        # Determine logo type and load content
        content = self._load_logo()

        # Pass content to Static constructor
        super().__init__(content, markup=True, **kwargs)

    def _find_logo(self, custom_path: Path | None) -> Path:
        """Find the best available logo file with fallback chain.

        Priority order:
        1. Custom path (if provided)
        2. logo.png (best quality, requires modern terminal with graphics support)
        3. logo.svg (vector format, not natively supported by terminals)
        4. logo.txt (ASCII art with colors - most compatible)
        5. Fallback to simple ASCII
        """
        if custom_path:
            return custom_path  # Return custom path even if it doesn't exist

        # Try PNG first (best quality, requires modern terminal)
        png_path = self.assets_dir / "logo.png"
        if png_path.exists():
            return png_path

        # Try SVG (needs conversion, not natively supported by terminals)
        # Fall through to TXT as terminals don't render SVG natively

        # Try TXT (ASCII art with colors - most compatible)
        txt_path = self.assets_dir / "logo.txt"
        if txt_path.exists():
            return txt_path

        # Fallback: no file
        return Path()

    def _load_logo(self) -> str:
        """Load logo content based on file type."""
        if not self.logo_path or not self.logo_path.exists():
            return self._fallback_logo()

        suffix = self.logo_path.suffix.lower()

        if suffix == ".png":
            # PNG: For now, fall back to ASCII art
            # Terminal graphics support requires Kitty/iTerm2 protocols
            # which need additional libraries and terminal detection
            return self._load_ascii_logo(
                self.assets_dir / "logo.txt"
                if (self.assets_dir / "logo.txt").exists()
                else None
            )

        elif suffix == ".txt":
            # TXT: ASCII art with colors
            return self._load_ascii_logo(self.logo_path)

        elif suffix == ".svg":
            # SVG: Not natively supported by terminals
            # Fall back to ASCII art
            return self._load_ascii_logo(
                self.assets_dir / "logo.txt"
                if (self.assets_dir / "logo.txt").exists()
                else None
            )

        return self._fallback_logo()

    def _load_ascii_logo(self, txt_path: Path | None = None) -> str:
        """Load colored ASCII logo content using Rich markup.

        Args:
            txt_path: Optional path to ASCII art file. If not provided, uses default logo.txt.

        Color scheme based on official SVG branding:
        - Mountain graphics: Arch Linux Blue (#1793D1)
        - ARCH text: White
        - linux text: Arch Linux Blue (#1793D1)
        - TM trademark: White
        """
        # Color variables for consistency - using official Arch Linux color
        ARCH_BLUE = "[#1793D1]"
        WHITE = "[white]"
        ARCH_BLUE_END = "[/#1793D1]"
        WHITE_END = "[/white]"

        # Use provided path or fall back to default logo.txt
        if txt_path is None:
            txt_path = self.assets_dir / "logo.txt"

        if not txt_path or not txt_path.exists():
            return self._fallback_logo()

        with open(txt_path, encoding="utf-8") as f:
            lines = [line.rstrip("\n") for line in f.readlines()]

        result = []
        for i, line in enumerate(lines):
            # Lines 7-10: Mountain (cyan) + ARCH text (white, cols 36-56) + rest (cyan)
            if 7 <= i <= 10:
                line_len = len(line)
                # Part 1: Columns 0-35 (mountain) - cyan
                part1 = line[:36]
                # Part 2: Columns 36-56 (ARCH text) - white  
                part2 = line[36:57] if line_len > 36 else ""
                # Part 3: Column 57+ (rest) - cyan
                part3 = line[57:] if line_len > 57 else ""
                
                # Check if TM is in the line
                if "TM" in line:
                    tm_index = line.rfind("TM")
                    # TM is in part3, handle it separately
                    if tm_index >= 57:
                        # Split part3 at TM
                        before_tm = part3[:tm_index - 57]
                        tm_part = part3[tm_index - 57:]
                        result.append(f"{ARCH_BLUE}{part1}{ARCH_BLUE_END}{WHITE}{part2}{WHITE_END}{ARCH_BLUE}{before_tm}{ARCH_BLUE_END} {WHITE}{tm_part}{WHITE_END}")
                    else:
                        # TM is in part2 (shouldn't happen based on logo structure)
                        result.append(f"{ARCH_BLUE}{part1}{ARCH_BLUE_END}{WHITE}{part2}{WHITE_END}{ARCH_BLUE}{part3}{ARCH_BLUE_END}")
                else:
                    # No TM, straightforward coloring
                    result.append(f"{ARCH_BLUE}{part1}{ARCH_BLUE_END}{WHITE}{part2}{WHITE_END}{ARCH_BLUE}{part3}{ARCH_BLUE_END}")
            # Lines with TM at end (e.g., line 18): Arch blue mountain + white TM
            elif "TM" in line and line.rstrip().endswith("TM"):
                tm_index = line.rfind("TM")
                before_tm = line[:tm_index].rstrip()
                tm_part = line[tm_index:]
                # Everything before TM is Arch blue, TM is white
                result.append(f"{ARCH_BLUE}{before_tm}{ARCH_BLUE_END} {WHITE}{tm_part}{WHITE_END}")
            else:
                # All other lines: Arch blue
                result.append(f"{ARCH_BLUE}{line}{ARCH_BLUE_END}")

        return "\n".join(result)

    def _fallback_logo(self) -> str:
        """Return simple fallback ASCII logo when no logo file is available."""
        return """
   [#1793D1]/\\[/#1793D1]
  [#1793D1]/  \\[/#1793D1]
 [#1793D1]/    \\[/#1793D1]
[#1793D1]/      \\[/#1793D1]
[#1793D1]--------[/#1793D1]
  [#1793D1]ARCH[/#1793D1]
"""

    def on_mount(self) -> None:
        self.add_class("logo-loaded")
