---
stepsCompleted:
  - step-01-init
  - step-02-discovery
  - step-03-core-experience
  - step-04-emotional-response
  - step-05-inspiration
  - step-06-design-system
  - step-07-defining-experience
  - step-08-visual-foundation
  - step-09-design-directions
  - step-10-user-journeys
  - step-11-component-strategy
  - step-12-ux-patterns
  - step-13-responsive-accessibility
  - step-14-complete
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
  - _bmad-output/planning-artifacts/epics.md
workflowType: 'ux-design'
project_name: 'ArchLinux Install'
user_name: 'Hans'
date: '2026-02-23'
---

# UX Design Specification - ArchLinux Install

**Author:** Hans
**Date:** 2026-02-23
**Type:** TUI Application (Terminal User Interface)

---

## 1. Executive Summary

ArchLinux Install es una herramienta de instalación de Arch Linux con interfaz TUI interactiva. El objetivo es proporcionar una experiencia guiada paso a paso que permita a usuarios de todos los niveles técnicos instalar Arch Linux sin necesidad de conocimientos avanzados de línea de comandos.

### Design Principles

1. **Simplicidad Guiada** - El usuario nunca debe sentirse perdido
2. **Feedback Constante** - Progreso visible en todo momento
3. **Seguridad** - Confirmaciones antes de operaciones destructivas
4. **Accesibilidad** - Navegación por teclado intuitiva
5. **Estética Arch** - Colores y estilo que reflejen la identidad de Arch Linux

---

## 2. User Experience Vision

### Target Users

| Usuario | Experiencia | Necesidades |
|---------|-------------|-------------|
| Novato | Sin conocimiento de Arch | Guía completa, sin opciones técnicas |
| Intermedio | Alguna experiencia Linux | Opciones personalizables |
| Administrador | Experiencia avanzada | Eficiencia, automatización |

### Core Experience Statement

> "Una instalación de Arch Linux que se siente como una conversación amigable, no como un examen técnico."

---

## 3. Visual Design System

### Color Palette

```
Primary Colors (Arch Linux Identity):
├── Arch Blue:    #1793D1  → Menú principal, acentos
├── Arch Cyan:    #00FFFF  → Highlights, selección activa
├── Dark Blue:    #0D1B2A  → Background principal
└── White:        #FFFFFF  → Texto principal

Semantic Colors:
├── Success:      #00FF00  → Operación completada
├── Warning:      #FFFF00  → Precaución requerida
├── Error:        #FF0000  → Error crítico
└── Info:         #1793D1  → Información adicional
```

### Typography

```
Terminal Font Stack:
├── Primary:   Monospace (system default)
├── Fallback:  DejaVu Sans Mono, Liberation Mono
└── Size:      14-16px (adaptable al terminal)
```

### Spacing System

```
Spacing Scale (characters/lines):
├── xs:  1 character
├── sm:  2 characters
├── md:  4 characters
├── lg:  6 characters
└── xl:  8 characters
```

---

## 4. Component Library

### 4.1 Main Menu Component

```
╔══════════════════════════════════════════════════════════╗
║                                                          ║
║                   ██████╗ ██████╗ ███████╗               ║
║                  ██╔════╝██╔═══██╗██╔════╝               ║
║                  ██║     ██║   ██║███████╗               ║
║                  ██║     ██║   ██║╚════██║               ║
║                  ╚██████╗╚██████╔╝███████║               ║
║                   ╚═════╝ ╚═════╝ ╚══════╝               ║
║                                                          ║
║              ArchLinux Install v1.0.0                    ║
║                                                          ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║   ┌─────────────────────────────────────────────────┐    ║
║   │  ▸ Nueva Instalación                            │    ║
║   │    Gestión de Particiones                       │    ║
║   │    Configuración de Red                         │    ║
║   │    Utilidades                                   │    ║
║   │    Salir                                        │    ║
║   └─────────────────────────────────────────────────┘    ║
║                                                          ║
║   [↑↓] Navegar    [Enter] Seleccionar    [q] Salir      ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

**Behaviors:**
- `↑/↓` or `j/k`: Navegación entre opciones
- `Enter`: Selección
- `q`: Salir
- `h`: Ayuda contextual

### 4.2 Progress Component

```
╔══════════════════════════════════════════════════════════╗
║  Instalando Sistema Base                                 ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  [████████████████████░░░░░░░░░░░░░░░░░░░░]  45%         ║
║                                                          ║
║  Descargando: linux-6.7.0-1-x86_64.pkg.tar.zst          ║
║  Velocidad: 12.5 MB/s                                   ║
║  Tiempo restante: ~3 minutos                            ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

**Behaviors:**
- Actualización en tiempo real
- Animación suave de progreso
- Cancelación con `Ctrl+C`

### 4.3 Confirmation Dialog

```
╔══════════════════════════════════════════════════════════╗
║  ⚠️  Confirmar Operación Destructiva                      ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  Está a punto de ELIMINAR TODAS las particiones en:     ║
║                                                          ║
║  /dev/sda (500 GB)                                       ║
║                                                          ║
║  Esta acción NO se puede deshacer.                       ║
║                                                          ║
║  ¿Está seguro de continuar?                              ║
║                                                          ║
║   [Sí, eliminar]    [No, cancelar]                       ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

**Behaviors:**
- Tab para cambiar entre opciones
- Colores de advertencia (amarillo/rojo)
- Requiere confirmación explícita

### 4.4 Form Input Component

```
╔══════════════════════════════════════════════════════════╗
║  Configuración de Usuario                                ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  Nombre de usuario:                                      ║
║  ┌─────────────────────────────────────────────────┐    ║
║  │ hans_                                             │    ║
║  └─────────────────────────────────────────────────┘    ║
║   ✓ Solo letras minúsculas, números y _                 ║
║                                                          ║
║  Contraseña:                                             ║
║  ┌─────────────────────────────────────────────────┐    ║
║  │ ••••••••                                          │    ║
║  └─────────────────────────────────────────────────┘    ║
║   Fortaleza: ████████░░ Fuerte                          ║
║                                                          ║
║  [Tab] Siguiente    [Enter] Confirmar                   ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

### 4.5 Partition Editor Component

```
╔══════════════════════════════════════════════════════════╗
║  Gestión de Particiones                                  ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  Disco: /dev/sda (500 GB) - SSD                          ║
║                                                          ║
║  ┌────────────────────────────────────────────────────┐ ║
║  │ # │ Tipo    │ Tamaño  │ Sistema │ Punto Montaje   │ ║
║  ├────────────────────────────────────────────────────┤ ║
║  │ 1 │ EFI     │ 512 MB  │ FAT32   │ /boot/efi       │ ║
║  │ 2 │ Root    │ 100 GB  │ ext4    │ /               │ ║
║  │ 3 │ Home    │ 350 GB  │ btrfs   │ /home           │ ║
║  │ 4 │ Swap    │ 8 GB    │ swap    │ swap            │ ║
║  └────────────────────────────────────────────────────┘ ║
║                                                          ║
║  Espacio libre: 41.5 GB                                  ║
║                                                          ║
║  [n] Nueva    [d] Eliminar    [e] Editar    [a] Aplicar ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

---

## 5. Screen Flows

### 5.1 Main Installation Flow

```
┌─────────────┐
│   Welcome   │
│   Screen    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Network   │──────┐
│ Validation  │      │ No
└──────┬──────┘      │
       │ Yes         ▼
       │        ┌─────────┐
       │        │  Error  │
       │        │  Screen │
       │        └────┬────┘
       │             │ Retry
       ▼             │
┌─────────────┐      │
│  Timezone   │◄─────┘
│ Selection   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Partition  │
│   Editor    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Confirm    │
│   Dialog    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Installation│
│  Progress   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Bootloader  │
│   Setup     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   User      │
│  Creation   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Complete   │
│   Screen    │
└─────────────┘
```

### 5.2 Error Recovery Flow

```
┌─────────────┐
│   Error     │
│  Detected   │
└──────┬──────┘
       │
       ▼
┌─────────────────────┐
│  Error Display      │
│  - Message          │
│  - Recovery options │
└──────┬──────────────┘
       │
       ├──[Retry]──► Return to failed step
       │
       ├──[Skip]───► Continue without (if possible)
       │
       ├──[Abort]──► Clean exit
       │
       └──[Help]───► Open documentation
```

---

## 6. Keyboard Navigation

### Global Shortcuts

| Key | Action |
|-----|--------|
| `↑/k` | Navegar arriba |
| `↓/j` | Navegar abajo |
| `←/h` | Retroceder / Ayuda |
| `→/l` | Avanzar / Seleccionar |
| `Enter` | Confirmar selección |
| `Esc` | Cancelar / Volver |
| `q` | Salir de la aplicación |
| `?` | Ayuda contextual |
| `Tab` | Siguiente campo |
| `Shift+Tab` | Campo anterior |

### Context-Specific Shortcuts

**Menu Screen:**
| Key | Action |
|-----|--------|
| `1-5` | Selección directa de opción |
| `/` | Búsqueda rápida |

**Partition Editor:**
| Key | Action |
|-----|--------|
| `n` | Nueva partición |
| `d` | Eliminar partición |
| `e` | Editar partición |
| `a` | Aplicar cambios |
| `u` | Deshacer |

**Progress Screen:**
| Key | Action |
|-----|--------|
| `Ctrl+C` | Cancelar operación |
| `l` | Ver log detallado |

---

## 7. Responsive Design

### Terminal Size Adaptation

```
Minimum: 80x24 (standard terminal)
├── Compact layout
├── Abbreviated text
└── Simplified graphics

Optimal: 120x30+
├── Full layout
├── All UI elements
└── Extended information

Large: 160x40+
├── Side panels
├── Log viewer
└── Additional metrics
```

### Size Detection Behavior

```go
func (m Model) View() string {
    width, height := m.termSize()
    
    switch {
    case width < 80:
        return m.compactView()
    case width < 120:
        return m.standardView()
    default:
        return m.extendedView()
    }
}
```

---

## 8. Accessibility Considerations

### Visual Accessibility

- **High Contrast Mode**: Opción para usuarios con baja visión
- **Color Independence**: Información no depende solo del color
- **Clear Typography**: Fuentes monoespaciadas legibles

### Motor Accessibility

- **Keyboard-Only Navigation**: Todas las funciones accesibles por teclado
- **Large Hit Areas**: Elementos seleccionables claramente delimitados
- **No Time Limits**: Sin operaciones con timeout forzado

### Cognitive Accessibility

- **Progressive Disclosure**: Información revelada gradualmente
- **Clear Language**: Sin jerga técnica innecesaria
- **Confirmation Steps**: Oportunidad de corregir errores

---

## 9. Animation & Transitions

### Transition Types

| Transition | Duration | Use Case |
|------------|----------|----------|
| Fade In | 200ms | Pantallas nuevas |
| Slide | 300ms | Navegación entre pantallas |
| Blink | 500ms | Alertas y advertencias |
| Spinner | Continuous | Operaciones en progreso |

### Implementation

```go
// Bubble Tea animation pattern
type tickMsg time.Time

func animate() tea.Cmd {
    return tea.Tick(100*time.Millisecond, func(t time.Time) tea.Msg {
        return tickMsg(t)
    })
}

func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
    switch msg.(type) {
    case tickMsg:
        m.progress += 0.01
        if m.progress < 1.0 {
            return m, animate()
        }
    }
    return m, nil
}
```

---

## 10. Error Handling UX

### Error Categories

| Category | Color | Icon | Recovery |
|----------|-------|------|----------|
| Info | Blue | ℹ️ | Continue |
| Warning | Yellow | ⚠️ | Acknowledge |
| Error | Red | ❌ | Retry/Abort |
| Critical | Red+Flash | 🚨 | Force Quit |

### Error Messages

```
╔══════════════════════════════════════════════════════════╗
║  ❌ Error de Red                                         ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  No se pudo conectar a los servidores de Arch Linux.     ║
║                                                          ║
║  Causa: Connection timeout after 30s                     ║
║                                                          ║
║  Sugerencias:                                            ║
║  • Verifique su conexión a internet                      ║
║  • Compruebe que no hay firewall bloqueando              ║
║  • Intente usar un mirror diferente                      ║
║                                                          ║
║  [Reintentar]    [Cambiar Mirror]    [Abortar]           ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

---

## 11. Success & Completion

### Success Screen

```
╔══════════════════════════════════════════════════════════╗
║                                                          ║
║                    🎉 ¡Instalación Completada!           ║
║                                                          ║
║              Arch Linux está listo para usar.            ║
║                                                          ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  Resumen:                                                ║
║  ─────────────────────────────────────────────           ║
║  • Sistema base: 287 paquetes instalados                 ║
║  • Bootloader: GRUB configurado en UEFI                  ║
║  • Usuario: hans (sudo habilitado)                       ║
║  • Zona horaria: America/New_York                        ║
║                                                          ║
║  Tiempo total: 12 minutos 34 segundos                    ║
║                                                          ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  [Reiniciar ahora]    [Instalar más paquetes]            ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

---

## 12. Implementation Notes

### Bubble Tea Integration

```go
// Main application structure
type Model struct {
    screen      Screen
    config      Config
    progress    float64
    err         error
    termWidth   int
    termHeight  int
}

// Screen types
type Screen int

const (
    ScreenWelcome Screen = iota
    ScreenNetwork
    ScreenTimezone
    ScreenPartition
    ScreenInstall
    ScreenComplete
    ScreenError
)

// View routing
func (m Model) View() string {
    switch m.screen {
    case ScreenWelcome:
        return m.welcomeView()
    case ScreenNetwork:
        return m.networkView()
    // ... etc
    }
}
```

### Lipgloss Styling

```go
var (
    // Colors
    archBlue  = lipgloss.Color("#1793D1")
    archCyan  = lipgloss.Color("#00FFFF")
    darkBg    = lipgloss.Color("#0D1B2A")
    
    // Styles
    titleStyle = lipgloss.NewStyle().
        Foreground(archCyan).
        Background(darkBg).
        Bold(true).
        Padding(0, 2)
    
    menuItemStyle = lipgloss.NewStyle().
        Foreground(lipgloss.Color("#FFFFFF")).
        Padding(0, 4)
    
    selectedStyle = lipgloss.NewStyle().
        Foreground(archCyan).
        Background(archBlue).
        Bold(true).
        Padding(0, 4)
)
```

---

## 13. Component Mapping to Stories

| UX Component | Epic | Stories |
|--------------|------|---------|
| Main Menu | EPIC-2 | STORY-2.1, 2.2, 2.3, 2.4 |
| Progress Bar | EPIC-5 | STORY-5.5 |
| Confirmation Dialog | EPIC-4 | STORY-4.5 |
| Form Inputs | EPIC-5 | STORY-5.4 |
| Partition Editor | EPIC-4 | STORY-4.1, 4.2, 4.3, 4.4 |
| Error Display | EPIC-5 | STORY-5.6 |
| Success Screen | EPIC-6 | STORY-6.5 |

---

*UX Design Specification generated via BMAD create-ux-design workflow*
