import pytest
from unittest.mock import patch

from archinstall_tui.cli.main import main


def test_main_list_languages(capsys):
    result = main(["--list-languages"])
    assert result == 0
    captured = capsys.readouterr()
    assert "Available languages:" in captured.out


def test_main_lang_flag(capsys):
    result = main(["--lang", "en", "--list-languages"])
    assert result == 0
    captured = capsys.readouterr()
    assert "Available languages:" in captured.out


def test_main_cli_mode_without_module():
    result = main(["--cli"])
    assert result == 1


def test_main_cli_mode_with_exit_module(capsys):
    result = main(["--cli", "--module", "exit"])
    assert result == 0
    captured = capsys.readouterr()
    assert "Module:" in captured.out
    assert "Status:" in captured.out


def test_main_cli_mode_with_new_install_module(capsys):
    result = main(["--cli", "--module", "new_install"])
    assert result == 0
    captured = capsys.readouterr()
    assert "Module:" in captured.out


def test_main_cli_mode_with_utilities_module(capsys):
    result = main(["--cli", "--module", "utilities"])
    captured = capsys.readouterr()
    assert "Module:" in captured.out
    assert "Status:" in captured.out


def test_main_debug_flag(capsys):
    result = main(["--debug", "--list-languages"])
    assert result == 0


def test_main_module_without_cli_flag():
    result = main(["--module", "exit"])
    assert result == 0


def test_main_tui_mode_error():
    with patch("archinstall_tui.tui.app.ArchInstallApp") as mock_app:
        mock_app.side_effect = Exception("TUI error")
        result = main([])
        assert result == 1
