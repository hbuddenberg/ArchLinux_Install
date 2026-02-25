# Product Requirements Document - ArchLinux Install

**Author:** Hans  
**Date:** 2026-02-21  
**Version:** 1.0

---

## 1. Executive Summary

### Project Overview
**ArchLinux Install** es una colección de scripts de shell que facilitan la instalación y configuración de Arch Linux, junto con herramientas de gestión de utilidades. El proyecto ofrece una interfaz TUI (Terminal User Interface) interactiva para guiar a los usuarios a través del proceso de instalación.

### Problem Statement
La instalación manual de Arch Linux requiere conocimiento técnico avanzado y múltiples pasos propensos a errores. Los usuarios necesitan una herramienta automatizada que simplifique este proceso manteniendo la flexibilidad y control.

### Goals
1. Automatizar el proceso de instalación de Arch Linux
2. Proporcionar una interfaz TUI intuitiva
3. Soportar configuración post-instalación
4. Incluir utilidades comunes (Hyprland, Plymouth, Remmina)
5. Migrar a una solución más mantenible (Go + Bubble Tea)

---

## 2. Product Vision

### Long-term Vision
Convertirse en la herramienta de referencia para instalación automatizada de Arch Linux, ofreciendo:
- Instalación base con opciones personalizables
- Configuración post-instalación modular
- Sistema de utilidades extensible
- Interfaz TUI moderna y accesible

### Target Audience
- Usuarios intermedios de Linux que desean Arch Linux
- Administradores de sistemas que despliegan múltiples instalaciones
- Entusiastas que buscan personalización

---

## 3. Functional Requirements

### 3.1 Core Installation Features

| ID | Feature | Priority | Description |
|----|---------|----------|-------------|
| F1 | Menú Principal | P0 | Navegación entre opciones: Nueva Instalación, Utilidades, Salir |
| F2 | Configuración de Fecha/Hora | P0 | Selección de timezone y locale del sistema |
| F3 | Actualización de Repositorios | P1 | Sincronización de mirrors y actualización de paquetes |
| F4 | Particionamiento de Discos | P0 | Creación de particiones (boot, root, swap, home) |
| F5 | Instalación Base | P0 | Ejecución de pacstrap y configuración de fstab |
| F6 | Instalación con Archinstall | P1 | Wrapper para método automatizado |
| F7 | Post-Instalación | P0 | Configuración de usuario, hostname, red, entorno de escritorio |
| F8 | Configuración de Swap | P2 | Archivo o partición swap |

### 3.2 Utility Features

| ID | Feature | Priority | Description |
|----|---------|----------|-------------|
| U1 | Hyprland Setup | P1 | Instalación de Hyprland + Waybar + SDDM |
| U2 | Plymouth Setup | P2 | Boot splash animation |
| U3 | Remmina Setup | P2 | Cliente RDP/VNC |
| U4 | Dotfiles Management | P2 | Vinculación de archivos a dotfiles |

### 3.3 Non-Functional Requirements

| ID | Requirement | Description |
|----|-------------|-------------|
| NF1 | Compatibilidad | Funcionar en Arch Linux Live ISO |
| NF2 | Privilegios | Manejo correcto de sudo/root |
| NF3 | Internacionalización | Soporte para múltiples idiomas |
| NF4 | Recuperación | Guardar estado para instalaciones interrumpidas |
| NF5 | Testing | Cobertura de tests >80% |

---

## 4. Technical Architecture (Propuesta de Migración)

### Estado Actual
- **Lenguaje**: Bash scripts
- **TUI**: Gum (Charm Bracelet)
- **Líneas de código**: ~1988
- **Módulos**: 15 scripts

### Propuesta Técnica (Migración a Go)

```
cmd/
├── main.go                 # Entry point
tui/
├── app.go                 # Modelo principal
├── screens/               # Pantallas
│   ├── main_menu/
│   ├── new_install/
│   └── utilities/
├── components/            # Componentes reutilizables
└── theme/                # Temas
internal/
├── commands/              # Ejecutores de comandos
├── state/                # Persistencia
├── i18n/                 # Internacionalización
└── sudo/                 # Manejo de privilegios
```

### Stack Tecnológico Propuesto
- **Lenguaje**: Go 1.21+
- **Framework TUI**: Bubble Tea (tea.Model)
- **Formularios**: Huh
- **Estilos**: Lipgloss
- **Componentes**: Bubbles
- **i18n**: go-i18n/v2

---

## 5. User Flows

### Flow 1: Nueva Instalación
```
Menú Principal → Nueva Instalación → 
  1. Fecha/Hora → 2. Pacman Update → 
  3. Particiones → 4. Instalar Arch → 
  5. Post-Instalación → Listo
```

### Flow 2: Utilidades
```
Menú Principal → Utilidades →
  [Hyprland|Plymouth|Remmina|Dotfiles] → Ejecutar
```

---

## 6. Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Pérdida de datos por particionado | Medium | High | Confirmaciones múltiples |
| Fallo de red durante instalación | Medium | Medium | Retry automático |
| Incompatibilidad con硬件 | Low | High | Detección de entorno |
| Migración a Go compleja | High | Medium | Fases incrementales |

---

## 7. Success Metrics

### KPIs
- [ ] Instalación exitosa en <30 minutos
- [ ] Interfaz TUI responsiva en terminales 80x24+
- [ ] Cobertura de tests >80%
- [ ] Binario estático <30MB
- [ ] Soporte ES/EN completo

---

## 8. Roadmap Propuesto

### Phase 1: Foundation (2 semanas)
- Setup de proyecto Go
- Theme system
- State persistence
- i18n setup

### Phase 2: Core TUI (3 semanas)
- App model
- Componentes base
- Menú principal

### Phase 3: Módulos Instalación (4 semanas)
- Todos los módulos de new_install

### Phase 4: Utilidades (2 semanas)
- Todos los módulos de utilities

### Phase 5: Testing + Polish (2 semanas)
- Integration tests
- Documentación
- Optimización de binary

**Total estimado**: 13-15 semanas

---

## 9. Appendix

### A. Project Structure (Actual)
```
ArchLinux_install/
├── src/
│   ├── main.sh
│   ├── configurations/
│   │   ├── user_configuration.json
│   │   └── user_credentials.json
│   └── modules/
│       ├── new_install/ (8 módulos)
│       └── utilities/ (4 módulos)
└── .devcontainer/
```

### B. Gum Commands Used
- `gum choose` - Menús de selección
- `gum confirm` - Confirmaciones
- `gum input` - Entrada de texto
- `gum style` - Estilos
- `gum spin` - Spinners

### C. Comparable Products
- **archinstall**: Herramienta oficial (Python)
- **Anarchy Linux**: Installer alternativo
- **Apricity OS**: Installer basado en Arch

---

*Documento generado automáticamente como parte del proceso de planificación.*
