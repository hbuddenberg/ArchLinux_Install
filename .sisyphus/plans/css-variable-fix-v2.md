# Plan: Fix CSS Variable Error in logo.py

## TL;DR

> Fix undefined CSS variable `$surface-dark` in logo.py DEFAULT_CSS
> Change to `$surface-darken-3` (valid Textual variable)

**Entregable**: TUI runs without CSS errors
**Esfuerzo**: Quick (1 line change)

---

## Contexto

### Error
```
Error in stylesheet:
/workspace/archinstall_tui/src/archinstall_tui/tui/widgets/logo.py, ArchLogo.DEFAULT_CSS:7:21
reference to undefined variable '$surface-dark'
did you mean '$surface-darken-3'?
```

### Causa
The variable `$surface-dark` is defined in TWO places:
1. `styles.tcss` - ✅ Already fixed
2. `logo.py` DEFAULT_CSS - ❌ Still broken

---

## TODOs

- [ ] 1. Fix CSS Variable in logo.py DEFAULT_CSS

  **Qué hacer**:
  - Editar `/workspace/archinstall_tui/src/archinstall_tui/tui/widgets/logo.py`
  - Línea 7 del DEFAULT_CSS: cambiar `background: $surface-dark;` → `background: $surface-darken-3;`

  **Archivo**:
  ```
  src/archinstall_tui/tui/widgets/logo.py
  ```

  **Change**:
  ```diff
  -        background: $surface-dark;
  +        background: $surface-darken-3;
  ```

  **QA Escenarios**:
  - Ejecutar `uv run archinstall-tui` → debe iniciar sin errores de CSS
  - Ejecutar `uv run pytest tests/` → todos los tests deben pasar

---

## Criterios de Éxito

- [ ] TUI inicia sin errores de stylesheet
- [ ] Todos los tests pasan (73 tests)
