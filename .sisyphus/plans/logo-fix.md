# Plan: Corregir Visualización del Logo en archinstall_tui

## TL;DR

> Corregir la visualización del logo de Arch Linux en la TUI:
> - Mostrar logo con ancho de 80 caracteres
> - Fondo de color diferente al menú para separación visual
> - Corregir escape de caracteres `\` que aparecen como `[/]`
>
> **Entregable**: Logo centrado, correctamente espaciado a 80 columnas, con fondo diferenciado
> **Esfuerzo**: Short
> **Ejecución**: Secuencial (dependencias simples)

---

## Contexto

### Problema Actual
1. El logo no se muestra en 80 caracteres de ancho - se ve más pequeño
2. El fondo del logo es igual al del menú - no hay separación visual
3. Los caracteres `\` aparecen como `[/]` - problema de escape de Rich markup

### Archivo Objetivo
`/workspace/archinstall_tui/src/archinstall_tui/assets/logo.txt` - contiene el logo actual

---

## Objetivos de Trabajo

### Objetivo Principal
Logo de Arch Linux centrado, con ancho de 80 caracteres, fondo diferenciado del menú

### Entregables Concrete
- [x] Logo mostrándose a 80 columnas de ancho
- [x] Fondo de color diferente al menú (sugerido: `$surface-dark` o `$primary-background`)
- [x] Caracteres `\` visibles correctamente (no como `[/]`)

### Definición de Done
- [x] `uv run archinstall-tui` muestra logo centrado a 80 columnas
- [x] Logo tiene fondo de color diferente al área del menú
- [x] No aparecen `[/]` en las líneas con `\`

### Must Have
- Logo centrado horizontalmente
- Ancho visual de 80 caracteres
- Separación visual clara entre logo y menú

### Must NOT Have
- Logo truncado o cortado
- Caracteres `[/]` visibles
- Fondo del mismo color que el menú

---

## Estrategia de Verificación

### Comando de Verificación
```bash
cd /workspace/archinstall_tui && uv run archinstall-tui
```

### Criterios de Aceptación
1. Logo visible con montaña (caracteres ▟█▙ etc)
2. Texto lateral visible (# * | a##e etc)
3. Ancho visual ~80 caracteres
4. Fondo del logo diferente al fondo del menú

---

## Tareas de Implementación

### Tarea 1: Simplificar Logo Widget

**Qué hacer**:
- Modificar `/workspace/archinstall_tui/src/archinstall_tui/tui/widgets/logo.py`
- Cambiar `markup=True` a `markup=False` en el Static del logo
- Esto evita que Rich procese los caracteres especiales como markup

**CSS adicional**:
- Agregar `background: $surface-dark;` o similar para fondo diferenciado

**QA Escenarios**:

Escenario: Logo se muestra sin errores de markup
  - Herramienta: Bash
  - Precondiciones: Ninguna
  - Pasos:
    1. Ejecutar `cd /workspace/archinstall_tui && uv run archinstall-tui`
    2. Capturar salida con timeout
  - Resultado Esperado: Logo visible sin `[/]` en las líneas
  - Evidencia: Captura de terminal

---

## Ondas de Ejecución

```
Onda 1 (Inmediata):
├── Tarea 1: Simplificar logo widget + fondo diferenciado
```

---

## Estrategia de Commit

- Mensaje: `fix: logo display - 80cols, bg color, no markup errors`
- Archivos: 
  - `src/archinstall_tui/tui/widgets/logo.py`
  - `src/archinstall_tui/tui/styles.tcss` (si necesita cambios)

---

## Criterios de Éxito

### Verificación Final
```bash
cd /workspace/archinstall_tui && uv run archinstall-tui
```

**Checklist**:
- [x] Logo centrado en pantalla
- [x] Ancho visual ~80 caracteres
- [x] Fondo del logo diferente al menú
- [x] Sin `[/]` visibles en el output
