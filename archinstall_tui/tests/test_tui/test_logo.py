from pathlib import Path

import pytest


def test_logo_widget_initialization():

    from archinstall_tui.tui.widgets.logo import ArchLogo

    logo = ArchLogo()
    assert "assets" in str(logo.logo_path)  # Default uses bundled asset
    # The logo_path could be .png, .svg, or .txt depending on what exists
    assert logo.logo_path.name in ["logo.png", "logo.svg", "logo.txt"]

def test_logo_widget_custom_path():

    from archinstall_tui.tui.widgets.logo import ArchLogo

    custom_path = Path("/custom/logo.txt")
    logo = ArchLogo(logo_path=custom_path)
    assert logo.logo_path == custom_path


def test_logo_fallback():

    from archinstall_tui.tui.widgets.logo import ArchLogo

    logo = ArchLogo(logo_path=Path("/nonexistent/logo.txt"))
    fallback = logo._fallback_logo()
    assert "ARCH" in fallback


def test_logo_load_missing_file():

    from archinstall_tui.tui.widgets.logo import ArchLogo

    logo = ArchLogo(logo_path=Path("/nonexistent/logo.txt"))
    content = logo._load_logo()
    assert "ARCH" in content


def test_logo_load_existing_file(tmp_path):

    from archinstall_tui.tui.widgets.logo import ArchLogo

    logo_file = tmp_path / "logo.txt"
    logo_file.write_text("CUSTOM LOGO")
    logo = ArchLogo(logo_path=logo_file)
    content = logo._load_logo()
    assert "CUSTOM LOGO" in content


def test_logo_default_css():

    from archinstall_tui.tui.widgets.logo import ArchLogo

    assert "ArchLogo" in ArchLogo.DEFAULT_CSS


def test_logo_applies_rich_markup_colors(tmp_path):

    from archinstall_tui.tui.widgets.logo import ArchLogo

    logo_file = tmp_path / "logo.txt"
    logo_file.write_text("ARCH")
    logo = ArchLogo(logo_path=logo_file)
    content = logo._load_logo()
    # Verificar que todo el logo usa el color azul de Arch Linux (#1793D1)
    assert "[#1793D1]" in content
    assert "[/#1793D1]" in content
    assert "ARCH" in content
    assert "ARCH" in content
