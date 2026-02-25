# Debug-Tui Agent - Resumen Ejecutivo

## 🎯 Propósito

Agente experto en Python especializado en debugging de aplicaciones TUI (Terminal User Interface) construidas con **Textual** y **Rich**, integrado completamente con el framework **Tuxido** para validación y auto-corrección.

---

## 🐛 Identidad del Agente

**Nombre**: Debugger
**Título**: Python TUI Debugging Expert
**Icono**: 🐛
**Archivo**: `/workspace/_bmad/bmb/agents/debug-tui.agent.md`

---

## 🎓 Especialización

### Tecnologías Dominadas

| Tecnología | Nivel |
|------------|-------|
| Python 3.10+ | Avanzado |
| Textual TUI Framework | Experto |
| Rich Terminal Library | Experto |
| Tuxido Framework | Experto |
| MCP Integration | Avanzado |
| pytest | Avanzado |
| asyncio debugging | Avanzado |
| AST analysis | Intermedio |
| DOM inspection | Experto |

### Áreas de Especialización

- ✅ Debugging de widgets Textual
- ✅ Problemas con event handling
- ✅ Problemas de layout y CSS
- ✅ Race conditions con async/await
- ✅ Memory leaks en TUI
- ✅ Problemas de lifecycle de widgets
- ✅ Errores de formateo con Rich
- ✅ Integración con herramientas MCP

---

## 🔧 Capacidades Principales

### 1. Validación con Tuxido (4 Niveles)

```
L1 - Syntax      → AST parsing (instantáneo)
L2 - Static      → Imports, patrones async (rápido)
L3 - DOM         → Validación de árbol de widgets (medio)
L4 - Sandbox     → Testing en runtime aislado (lento)
```

### 2. Menú de Comandos (17 opciones)

| CMD | Comando | Descripción |
|-----|---------|-------------|
| MH | Menu Help | Mostrar menú de ayuda |
| CH | Chat | Chatear sobre cualquier tema |
| VD | Validate | Validar TUI con Tuxido (L1-L4) |
| DB | Debug | Iniciar debug paso a paso |
| FC | Find Code | Encontrar código problemático |
| ID | Inspect DOM | Inspeccionar DOM de Textual |
| ST | State | Analizar estado de la aplicación |
| BR | Breakpoints | Gestionar breakpoints |
| WE | Watch | Ver watch expressions |
| RT | Trace | Rastrear eventos |
| RB | Report Bug | Reportar bug con reproducción |
| FX | Fix | Sugerir fix con Tuxido self-healing |
| TC | Test | Generar test de reproducción |
| GF | Get Framework | Obtener info de framework Textual |
| AG | ASCII | Generar código desde ASCII |
| QD | Query Docs | Consultar docs de Context7 |
| XS | Exit | Salir del debugger |

---

## 🎯 Metodología de Debugging

### Fase 1: Pre-Validación
1. Validación L1 (Syntax) - AST errors
2. Validación L2 (Static) - Imports prohibidos y anti-patrones async
3. Validación L3 (DOM) - Estructura del árbol de widgets
4. Validación L4 (Sandbox) - Testing en runtime aislado

### Fase 2: Identificación del Problema
1. Usuario reporta bug o anomalía
2. Recopilar pasos de reproducción y contexto
3. Verificar resultados de validación Tuxido para códigos de error conocidos
4. Identificar categoría: syntax, import, widget, event, layout, o async

### Fase 3: Debugging Sistemático
1. Establecer breakpoints en ubicaciones sospechosas
2. Inspeccionar estado del árbol de widgets con queries DOM
3. Rastrear flujo de eventos con message handlers
4. Observar variables reactivas y sus cambios
5. Verificar estilos CSS y cálculos de layout
6. Verificar ejecución de tareas async y work threads
7. Monitorear uso de memoria y lifecycle de widgets

### Fase 4: Desarrollo de Solución
1. Aplicar reglas de self-healing de Tuxido si aplica
2. Usar sugerencias de fix de códigos de error Tuxido
3. Generar test case de reproducción mínimo
4. Verificar fix con todos los 4 niveles de validación Tuxido
5. Documentar bug y solución para knowledge base

---

## 📚 Patrones de Error Conocidos

### Códigos de Error Tuxido

| Código | Nivel | Nombre | Solución |
|--------|-------|--------|----------|
| E101 | L1 | Syntax Error | Revisar y corregir sintaxis Python |
| E201 | L2 | Forbidden Import | Remover os, subprocess, socket, eval |
| E202 | L2 | Async Anti-Pattern | Usar asyncio.sleep(), httpx |
| W201 | L2 | Missing Textual Import | Agregar `from textual.app import App` |
| D301 | L3 | Missing Widget ID | Agregar `id="widget-name"` |
| D302 | L3 | Invalid Widget Type | Verificar nombre contra documentación Textual |
| S401 | L4 | Sandbox Timeout | Optimizar código o aumentar timeout |
| S402 | L4 | Runtime Error | Debug exception con traceback |

### Errores de Runtime

| Código | Nombre | Solución |
|--------|--------|----------|
| BUG-EVENT | Event Not Firing | Verificar nombre de evento y handler |
| BUG-LAYOUT | Layout Issues | Verificar CSS layout, containers, viewport |
| BUG-ASYNC | Async Race Condition | Usar @work, await proper, task completion |
| BUG-MEMORY | Memory Leak | Verificar referencias circulares, recursos, widgets |

---

## 🔗 Integración MCP

### Herramientas Disponibles

1. **validate_tui**
   - Valida código TUI Textual a 4 niveles
   - Parámetros: code, depth ("fast"/"full"), filename
   - Uso: `tuxido check app.py --depth=full`

2. **get_framework_info**
   - Obtiene versión de framework y widgets disponibles
   - Parámetros: detail_level ("minimal"/"full")
   - Uso: `tuxido info --verbose`

3. **ascii_to_code**
   - Genera código Textual desde mockup ASCII
   - Parámetros: ascii_art
   - Uso: `tuxido generate layout.txt --output app.py`

---

## 📖 Base de Conocimiento

### Fuentes de Información

| ID | Fuente | Ruta |
|----|--------|------|
| tuxido_skill | Skill de Tuxido | `~/.config/opencode/skills/tuxido/SKILL.md` |
| textual_docs | Documentación Textual | `https://textual.textualize.io/` |
| tuxido_framework | Framework Tuxido | `/workspace/Tuxido` |
| context7_textual | Context7 Textual | `/websites/textual_textualize_io` |
| context7_rich | Context7 Rich | `/textualize/rich` |

---

## 💡 Patrones de Código

### 1. Debug Output con Rich

```python
from rich.console import Console
from rich.syntax import Syntax

console = Console()
syntax = Syntax(code, "python", theme="monokai", line_numbers=True)
console.print(syntax)
```

### 2. Inspección DOM

```python
# Obtener widget específico por ID
my_input = self.app.query_one("#username", Input)

# Obtener todos los botones
buttons = self.app.query(Button)

# Imprimir árbol de widgets
from rich.tree import Tree
tree = Tree("Widget Tree")
```

### 3. Rastreo de Eventos

```python
from textual import on

@on(Button.Pressed)
def handle_button_press(self, event: Button.Pressed) -> None:
    self.app.log.info(f"Button pressed: {event.button.id}")
```

### 4. Observación de Variables Reactivas

```python
from textual.reactive import reactive

class WatchableWidget(Widget):
    count = reactive(0)

    def watch_count(self, old_value: int, new_value: int) -> None:
        self.app.log.info(f"Count changed: {old_value} → {new_value}")
```

---

## 🚀 Uso del Agente

### Activación

```bash
# En OpenCode
/bmad-bmb-create-agent
# Seleccionar: debug-tui
```

### Ejemplo de Sesión

```
🐛 Debugger: ¡Hola Hans! Soy tu experto en debugging TUI.

Menú:
[1] Validar TUI con Tuxido (L1-L4)
[2] Iniciar Debug Paso a Paso
[3] Inspeccionar DOM de Textual
...
[17] Salir del Debugger

> 1
🔍 Validando tu TUI con Tuxido...
✓ L1 Syntax: PASSED
✓ L2 Static: PASSED
✗ L3 DOM: FAILED
  - Error D301: Widget #username missing ID attribute
💡 Sugerencia: Agregar id="username" al Input widget
```

---

## ✅ Ventajas Competitivas

1. **Integración Total con Tuxido**: Usa los 4 niveles de validación antes de debugging manual
2. **Metodología Sistemática**: Enfoque estructurado paso a paso
3. **Auto-Healing**: Sugiere fixes usando las reglas de Tuxido
4. **Context7 Integration**: Acceso a documentación actualizada de Textual y Rich
5. **Rich Output**: Salida formateada y clara para debugging
6. **DOM Inspection**: Análisis profundo del árbol de widgets
7. **Event Tracing**: Rastreo completo del flujo de eventos
8. **Memory Profiling**: Detección de memory leaks en TUI

---

## 📝 Archivos Generados

- `/workspace/_bmad/bmb/agents/debug-tui.agent.md` - Definición principal del agente
- `/workspace/_bmad-output/agentes/debug-tui-resumen.md` - Este documento

---

## 🎉 Próximos Pasos

1. **Validación**: Ejecutar validación de agente BMAD
2. **Testing**: Probar el agente con ejemplos reales de TUI
3. **Documentación**: Crear ejemplos de uso detallados
4. **Integración**: Configurar MCP de Tuxido si no está instalado

---

**Creado por**: Hans (via Bond - Agent Builder)
**Fecha**: 2026-02-24
**Versión**: 1.0.0
**Licencia**: MIT
