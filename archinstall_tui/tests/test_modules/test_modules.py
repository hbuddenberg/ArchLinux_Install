import pytest
from archinstall_tui.modules.base import Module, ModuleInfo, ModuleResult
from archinstall_tui.modules.new_install.module import NewInstallModule
from archinstall_tui.modules.utilities.module import UtilitiesModule
from archinstall_tui.modules.exit.module import ExitModule


def test_new_install_module_info():
    module = NewInstallModule()
    assert module.info.id == "new_install"
    assert module.info.icon == "📦"


def test_new_install_module_wizard():
    module = NewInstallModule()
    result = module.run(subcommand="wizard")
    assert result.success is True
    assert result.data["mode"] == "wizard"


def test_new_install_module_unknown_subcommand():
    module = NewInstallModule()
    result = module.run(subcommand="unknown")
    assert result.success is False


def test_utilities_module_info():
    module = UtilitiesModule()
    assert module.info.id == "utilities"
    assert module.info.icon == "🔧"


def test_utilities_module_unknown_subcommand():
    module = UtilitiesModule()
    result = module.run(subcommand="unknown")
    assert result.success is False


def test_utilities_module_menu_subcommand():
    module = UtilitiesModule()
    result = module.run(subcommand="menu")
    assert result.success is True
    assert "hyprland" in result.message
    assert "plymouth" in result.message
    assert result.data["options"] == ["hyprland", "plymouth", "remmina", "dotfiles"]

def test_exit_module_info():
    module = ExitModule()
    assert module.info.id == "exit"
    assert module.info.icon == "🚪"


def test_exit_module_without_confirm():
    module = ExitModule()
    result = module.run(confirm=False)
    assert result.success is True
    assert result.data["requires_confirmation"] is True


def test_exit_module_with_confirm():
    module = ExitModule()
    result = module.run(confirm=True)
    assert result.success is True
    assert result.data["should_exit"] is True
