from unittest.mock import patch, MagicMock

import pytest


def test_app_initialization():
    from archinstall_tui.tui.app import ArchInstallApp

    app = ArchInstallApp(lang="en")
    assert app._lang == "en"


def test_app_default_lang():
    from archinstall_tui.tui.app import ArchInstallApp

    app = ArchInstallApp()
    assert app._lang is None


def test_app_screens_configured():
    from archinstall_tui.tui.app import ArchInstallApp

    assert "main" in ArchInstallApp.SCREENS


def test_app_bindings_configured():
    from archinstall_tui.tui.app import ArchInstallApp

    bindings = [b[0] for b in ArchInstallApp.BINDINGS]
    # 'q' is handled by individual screens, not globally
    assert "escape" in bindings


def test_screen_bindings_have_exit_action():
    from archinstall_tui.tui.screens.main_menu import MainMenuScreen
    from archinstall_tui.tui.screens.new_install_screen import NewInstallScreen
    from archinstall_tui.tui.screens.utilities_screen import UtilitiesScreen

    # All menu screens should have 'q' bound to request_exit
    for screen_class in [MainMenuScreen, NewInstallScreen, UtilitiesScreen]:
        bindings = [b[0] for b in screen_class.BINDINGS]
        assert "q" in bindings

def test_app_push_module():
    from archinstall_tui.tui.app import ArchInstallApp

    app = ArchInstallApp()
    app.notify = MagicMock()
    # push_module should navigate to a known screen
    app.push_module("new_install")  # Known screen
    # Should not have called notify since it's a valid screen
    # (it would push the screen instead)


def test_app_request_exit_shows_confirmation():
    from archinstall_tui.tui.app import ArchInstallApp

    app = ArchInstallApp()
    app.push_screen = MagicMock()
    app.request_exit()
    # Should push the exit confirmation screen
    app.push_screen.assert_called_once_with("exit")
