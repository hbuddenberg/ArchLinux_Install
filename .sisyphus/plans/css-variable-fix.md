# Plan: Fix CSS Variable Error

## TL;DR

> Fix undefined CSS variable `$surface-dark` in styles.tcss
> Change to `$surface-darken-3` (valid Textual variable)

**Entregable**: TUI runs without CSS errors
**Esfuerzo**: Quick (1 line change)

---

## Contexto

### Error
```
Error in stylesheet:
/workspace/archinstall_tui/src/archinstall_tui/tui/styles.tcss:48:17
reference to undefined variable '$surface-dark'
did you mean '$surface-darken-3'?
```

### Causa
The variable `$surface-dark` does not exist in Textual's CSS variables. The correct variable is `$surface-darken-3`.

---

## TODOs

- [x] 1. Fix CSS Variable in styles.tcss

  **Qué hacer**:
  - Editar `/workspace/archinstall_tui/src/archinstall_tui/tui/styles.tcss`
  - Línea 48: cambiar `background: $surface-dark;` → `background: $surface-darken-3;`

  **Archivo**:
  ```
  src/archinstall_tui/tui/styles.tcss
  ```

  **Change**:
  ```diff
  -    background: $surface-dark;
  +    background: $surface-darken-3;
  ```

  **QA Escenarios**:
  - Ejecutar `uv run archinstall-tui` → debe iniciar sin errores de CSS

---

## Criterios de Éxito

- [x] TUI inicia sin errores de stylesheet
- [x] Logo tiene fondo oscuro diferenciado del menú
