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
    assert "q" in bindings
    assert "escape" in bindings


def test_app_push_module():
    from archinstall_tui.tui.app import ArchInstallApp

    app = ArchInstallApp()
    app.notify = MagicMock()
    app.push_module("test_module")
    app.notify.assert_called_once()


def test_app_request_exit():
    from archinstall_tui.tui.app import ArchInstallApp

    app = ArchInstallApp()
    app.action_quit = MagicMock()
    app.request_exit()
    app.action_quit.assert_called_once()
