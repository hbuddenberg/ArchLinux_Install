import logging
from pathlib import Path


def get_logger(name: str, level: int | None = None) -> logging.Logger:
    logger = logging.getLogger(name)

    if logger.handlers:
        return logger

    log_dir = Path.home() / ".config" / "archinstall_tui" / "logs"
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / "archinstall.log"

    formatter = logging.Formatter(
        fmt="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    file_handler = logging.FileHandler(log_file, encoding="utf-8")
    file_handler.setFormatter(formatter)
    file_handler.setLevel(logging.DEBUG)
    logger.addHandler(file_handler)

    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)
    console_handler.setLevel(logging.INFO)
    logger.addHandler(console_handler)

    logger.setLevel(level or logging.DEBUG)

    return logger


def set_log_level(logger: logging.Logger, level: int) -> None:
    logger.setLevel(level)
    for handler in logger.handlers:
        if isinstance(handler, logging.StreamHandler) and not isinstance(
            handler, logging.FileHandler
        ):
            handler.setLevel(level)
