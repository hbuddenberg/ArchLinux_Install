import json
from dataclasses import dataclass
from pathlib import Path


@dataclass
class Config:
    lang: str = "es"
    log_level: str = "INFO"
    theme: str = "arch"

    @classmethod
    def from_file(cls, path: Path | None = None) -> "Config":
        if path is None:
            path = Path.home() / ".config" / "archinstall_tui" / "config.json"

        if not path.exists():
            return cls()

        with open(path, encoding="utf-8") as f:
            data = json.load(f)

        return cls(
            lang=data.get("lang", "es"),
            log_level=data.get("log_level", "INFO"),
            theme=data.get("theme", "arch"),
        )

    def save(self, path: Path | None = None) -> None:
        if path is None:
            path = Path.home() / ".config" / "archinstall_tui" / "config.json"

        path.parent.mkdir(parents=True, exist_ok=True)

        with open(path, "w", encoding="utf-8") as f:
            json.dump(
                {"lang": self.lang, "log_level": self.log_level, "theme": self.theme},
                f,
                indent=2,
            )


_config: Config | None = None


def get_config(reload: bool = False) -> Config:
    global _config

    if _config is None or reload:
        _config = Config.from_file()

    return _config


def set_config(config: Config) -> None:
    global _config
    _config = config
