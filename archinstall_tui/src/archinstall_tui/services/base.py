from abc import ABC, abstractmethod
from dataclasses import dataclass


@dataclass
class ServiceResult:
    success: bool
    output: str
    error: str | None = None
    exit_code: int = 0


class Service(ABC):
    @abstractmethod
    def execute(self, *args, **kwargs) -> ServiceResult:
        pass
