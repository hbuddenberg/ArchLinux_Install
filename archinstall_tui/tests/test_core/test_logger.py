import logging
from pathlib import Path

from archinstall_tui.core.logger import get_logger, set_log_level


def test_get_logger_returns_logger():
    logger = get_logger("test_module")
    assert isinstance(logger, logging.Logger)
    assert logger.name == "test_module"


def test_get_logger_creates_handlers():
    logger = get_logger("test_handlers")
    assert len(logger.handlers) == 2


def test_get_logger_singleton():
    logger1 = get_logger("singleton_test")
    logger2 = get_logger("singleton_test")
    assert logger1 is logger2


def test_log_file_created():
    get_logger("file_test")
    log_path = Path.home() / ".config" / "archinstall_tui" / "logs" / "archinstall.log"
    assert log_path.parent.exists()


def test_set_log_level():
    logger = get_logger("level_test")
    set_log_level(logger, logging.WARNING)
    assert logger.level == logging.WARNING
