from archinstall_tui.modules.base import Module, ModuleInfo, ModuleResult


def test_module_info_defaults():
    info = ModuleInfo(id="test", name="Test", description="Test module")
    assert info.id == "test"
    assert info.icon is None


def test_module_info_with_icon():
    info = ModuleInfo(id="test", name="Test", description="Test", icon="🔧")
    assert info.icon == "🔧"


def test_module_result_defaults():
    result = ModuleResult(success=True, message="Done")
    assert result.success is True
    assert result.data is None


def test_module_result_with_data():
    result = ModuleResult(success=True, message="Done", data={"key": "value"})
    assert result.data == {"key": "value"}


def test_module_is_abstract():
    assert Module.__abstractmethods__ == frozenset({"info", "run"})
