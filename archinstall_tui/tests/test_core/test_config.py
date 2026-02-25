import json
from pathlib import Path

from archinstall_tui.core.config import Config, get_config, set_config


def test_config_defaults():
    config = Config()
    assert config.lang == "es"
    assert config.log_level == "INFO"
    assert config.theme == "arch"


def test_config_from_file_not_exists(tmp_path):
    config = Config.from_file(tmp_path / "nonexistent.json")
    assert config.lang == "es"


def test_config_from_file_exists(tmp_path):
    config_file = tmp_path / "config.json"
    config_file.write_text(json.dumps({"lang": "en", "log_level": "DEBUG"}))

    config = Config.from_file(config_file)
    assert config.lang == "en"
    assert config.log_level == "DEBUG"


def test_config_save(tmp_path):
    config = Config(lang="en", log_level="DEBUG", theme="dark")
    config_file = tmp_path / "config.json"

    config.save(config_file)

    with open(config_file) as f:
        data = json.load(f)

    assert data["lang"] == "en"
    assert data["log_level"] == "DEBUG"


def test_get_config_returns_config():
    config = get_config()
    assert isinstance(config, Config)


def test_set_config():
    new_config = Config(lang="en")
    set_config(new_config)

    config = get_config()
    assert config.lang == "en"
