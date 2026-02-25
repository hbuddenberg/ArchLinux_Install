# Plan: Actualizar Dependencias y Versión 0.2.0

## TL;DR

> **Quick Summary**: Actualizar pyproject.toml con versiones correctas de dependencias y cambiar versión del proyecto a 0.2.0
> 
> **Deliverables**:
> - Versión actualizada a 0.2.0
> - Dependencias actualizadas a versiones actuales
> - Eliminar duplicados en configuración

---

## Contexto

### Estado Actual
```toml
version = "0.1.0"

dependencies = [
    "textual>=0.47.0",
    "rich>=13.7.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0.0",
    "pytest-asyncio>=0.23.0",
    "pytest-cov>=4.1.0",
    "ruff>=0.2.0",
]

[dependency-groups]  # DUPLICADO - debe eliminarse
dev = [
    "pytest>=9.0.2",
    "pytest-asyncio>=1.3.0",
    "pytest-cov>=7.0.0",
]
```

### Versiones Instaladas (actuales)
| Paquete | Versión Instalada |
|---------|------------------|
| textual | 8.0.0 |
| rich | 14.3.3 |
| pytest | 9.0.2 |
| pytest-asyncio | 1.3.0 |
| pytest-cov | 7.0.0 |

### Estado Deseado
```toml
version = "0.2.0"

dependencies = [
    "textual>=8.0.0",
    "rich>=14.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=9.0.0",
    "pytest-asyncio>=1.3.0",
    "pytest-cov>=7.0.0",
    "ruff>=0.9.0",
]

# Eliminar [dependency-groups] - es duplicado
```

---

## TODOs

- [x] 1. Actualizar versión del proyecto a 0.2.0

  **What to do**:
  - Cambiar `version = "0.1.0"` a `version = "0.2.0"`

- [x] 2. Actualizar dependencias principales

  **What to do**:
  - textual: `>=0.47.0` → `>=8.0.0`
  - rich: `>=13.7.0` → `>=14.0.0`

- [x] 3. Actualizar dependencias de desarrollo

  **What to do**:
  - pytest: `>=8.0.0` → `>=9.0.0`
  - pytest-asyncio: `>=0.23.0` → `>=1.3.0`
  - pytest-cov: `>=4.1.0` → `>=7.0.0`
  - ruff: `>=0.2.0` → `>=0.9.0`

- [x] 4. Eliminar sección duplicada [dependency-groups]

  **What to do**:
  - Eliminar todo el bloque `[dependency-groups]` que está duplicado

- [x] 5. Verificar que todo funciona

  **What to do**:
  - Ejecutar `uv sync`
  - Ejecutar `uv run pytest --cov`
  - Verificar que tests pasan

---

## Archivo Final Esperado

```toml
[project]
name = "archinstall-tui"
version = "0.2.0"
description = "ArchLinux Installation TUI with Python + Textual"
readme = "README.md"
requires-python = ">=3.11"
license = { text = "MIT" }
authors = [{ name = "Hans Buddenberg" }]
keywords = ["archlinux", "tui", "installer", "textual"]

dependencies = [
    "textual>=8.0.0",
    "rich>=14.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=9.0.0",
    "pytest-asyncio>=1.3.0",
    "pytest-cov>=7.0.0",
    "ruff>=0.9.0",
]

[project.scripts]
archinstall-tui = "archinstall_tui.cli.main:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/archinstall_tui"]

[tool.ruff]
target-version = "py311"
line-length = 88
src = ["src", "tests"]

[tool.ruff.lint]
select = ["E", "W", "F", "I", "B", "C4", "UP", "ARG", "SIM"]
ignore = ["E501", "B008"]

[tool.ruff.lint.isort]
known-first-party = ["archinstall_tui"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"

[tool.pytest.ini_options]
asyncio_mode = "auto"
testpaths = ["tests"]
pythonpath = ["src"]
addopts = "-v --tb=short"

[tool.coverage.run]
source = ["src/archinstall_tui"]
branch = true

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
]
```

---

## Success Criteria

- [x] Versión 0.2.0 en pyproject.toml
- [x] Dependencias actualizadas
- [x] Sin duplicados
- [x] `uv sync` ejecuta sin errores
- [x] `uv run pytest --cov` pasa con 80% coverage (71 tests)
