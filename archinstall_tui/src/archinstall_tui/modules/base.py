from abc import ABC, abstractmethod
from dataclasses import dataclass


@dataclass
class ModuleInfo:
    id: str
    name: str
    description: str
    icon: str | None = None


@dataclass
class ModuleResult:
    success: bool
    message: str
    data: dict | None = None


class Module(ABC):
    @property
    @abstractmethod
    def info(self) -> ModuleInfo:
        pass

    @abstractmethod
    def run(self, *args, **kwargs) -> ModuleResult:
        pass

    def __repr__(self) -> str:
        return f"<Module:{self.info.id}>"
