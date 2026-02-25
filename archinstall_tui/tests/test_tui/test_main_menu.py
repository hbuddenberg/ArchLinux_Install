

import pytest


def test_main_menu_screen_import():

    from archinstall_tui.tui.screens.main_menu import MainMenuScreen

    assert MainMenuScreen is not None


def test_main_menu_screen_bindings():

    from archinstall_tui.tui.screens.main_menu import MainMenuScreen

    bindings = [b[0] for b in MainMenuScreen.BINDINGS]
    assert "q" in bindings


def test_main_menu_screen_css():

    from archinstall_tui.tui.screens.main_menu import MainMenuScreen

    assert MainMenuScreen.CSS_PATH is not None
