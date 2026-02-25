---
stepsCompleted:
  - step-01-init
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
workflowType: 'epics-stories'
project_name: 'ArchLinux Install'
user_name: 'Hans'
date: '2026-02-23'
---

# Epics & Stories - ArchLinux Install

## Overview

Este documento desglosa los requisitos del PRD en Épicas y User Stories para implementación.

---

## Epic 1: Foundation

**Objetivo:** Establecer la base técnica del proyecto

### STORY-1.1: Go Module Initialization

**Como** desarrollador
**Quiero** un Go module inicializado con dependencias
**Para** tener la base del proyecto lista

**Acceptance Criteria:**
- [ ] `go.mod` creado con module path correcto
- [ ] Dependencias Bubble Tea, Huh, Lipgloss instaladas
- [ ] `go build` ejecuta sin errores

**Complejidad:** Baja

---

### STORY-1.2: Configuration System

**Como** desarrollador
**Quiero** un sistema de configuración JSON
**Para** persistir preferencias del usuario

**Acceptance Criteria:**
- [ ] Struct Config definido con campos del PRD
- [ ] Load/Save functions implementadas
- [ ] Validation de configuración

**Complejidad:** Media

---

### STORY-1.3: Command Execution Layer

**Como** desarrollador
**Quiero** una abstracción para ejecutar comandos
**Para** testear sin ejecutar comandos reales

**Acceptance Criteria:**
- [ ] Interface CommandRunner definida
- [ ] SafeRunner con timeout implementado
- [ ] MockRunner para tests

**Complejidad:** Media

---

### STORY-1.4: Bubble Tea Scaffold

**Como** desarrollador
**Quiero** un modelo base de Bubble Tea
**Para** iniciar la aplicación TUI

**Acceptance Criteria:**
- [ ] Model struct con state management
- [ ] Update function con message routing
- [ ] View function básica

**Complejidad:** Media

---

### STORY-1.5: Root Privilege Validation

**Como** usuario
**Quiero** que la aplicación valide permisos root
**Para** evitar errores durante instalación

**Acceptance Criteria:**
- [ ] ValidateRootAccess() implementado
- [ ] Error message claro si no hay permisos
- [ ] Exit code apropiado

**Complejidad:** Baja

---

## Epic 2: Menu Navigation

**Objetivo:** Implementar navegación principal (RF-01)

### STORY-2.1: Main Menu Model

**Como** usuario
**Quiero** ver un menú principal con opciones
**Para** navegar por la aplicación

**Acceptance Criteria:**
- [ ] MenuModel con opciones del PRD
- [ ] Navegación con flechas
- [ ] Selección con Enter

**Complejidad:** Baja

---

### STORY-2.2: Menu Styling

**Como** usuario
**Quiero** un menú visualmente atractivo
**Para** mejor experiencia de uso

**Acceptance Criteria:**
- [ ] Lipgloss styles aplicados
- [ ] Colores Arch Linux (cyan)
- [ ] Logo ASCII visible

**Complejidad:** Baja

---

### STORY-2.3: Sub-Menu Navigation

**Como** usuario
**Quiero** navegar a sub-menús
**Para** acceder a módulos específicos

**Acceptance Criteria:**
- [ ] Transición Menu → Module
- [ ] Back navigation funcionando
- [ ] State preservation

**Complejidad:** Media

---

### STORY-2.4: Menu Tests

**Como** desarrollador
**Quiero** tests del menú
**Para** asegurar comportamiento correcto

**Acceptance Criteria:**
- [ ] Unit tests para MenuModel
- [ ] Test navigation flow
- [ ] ≥80% coverage

**Complejidad:** Baja

---

## Epic 3: Pre-Installation

**Objetivo:** Configuración previa a instalación (RF-02, RF-06, RF-07)

### STORY-3.1: Timezone Selection

**Como** usuario
**Quiero** seleccionar mi zona horaria
**Para** configurar el sistema correctamente

**Acceptance Criteria:**
- [ ] Lista de timezones disponible
- [ ] Búsqueda/filtrado
- [ ] Selección guardada en config

**Complejidad:** Baja

---

### STORY-3.2: Network Validation

**Como** usuario
**Quiero** validar mi conexión a internet
**Para** asegurar descarga de paquetes

**Acceptance Criteria:**
- [ ] Ping test implementado
- [ ] Error message si no hay conexión
- [ ] Retry option

**Complejidad:** Baja

---

### STORY-3.3: Pacman Update Module

**Como** usuario
**Quiero** actualizar paquetes del sistema
**Para** tener versiones más recientes

**Acceptance Criteria:**
- [ ] pacman -Syu wrapper
- [ ] Progress indication
- [ ] Error handling

**Complejidad:** Media

---

### STORY-3.4: Pre-flight Checks

**Como** usuario
**Quiero** ver un resumen antes de instalar
**Para** confirmar la configuración

**Acceptance Criteria:**
- [ ] Checklist de validaciones
- [ ] Resumen de configuración
- [ ] Confirmación antes de proceder

**Complejidad:** Media

---

### STORY-3.5: Pre-Installation Tests

**Como** desarrollador
**Quiero** tests de pre-instalación
**Para** verificar lógica de validación

**Acceptance Criteria:**
- [ ] Tests para timezone
- [ ] Tests para network validation
- [ ] Mock para pacman operations

**Complejidad:** Baja

---

## Epic 4: Partition Management

**Objetivo:** Gestión de particiones (RF-03)

### STORY-4.1: Disk Discovery

**Como** usuario
**Quiero** ver los discos disponibles
**Para** seleccionar donde instalar

**Acceptance Criteria:**
- [ ] Listar /dev/sd* y /dev/nvme*
- [ ] Mostrar tamaño y tipo
- [ ] Selección de disco

**Complejidad:** Media

---

### STORY-4.2: Partition List View

**Como** usuario
**Quiero** ver particiones existentes
**Para** decidir qué hacer

**Acceptance Criteria:**
- [ ] Lista de particiones del disco
- [ ] Información: tamaño, tipo, mount point
- [ ] Refresh capability

**Complejidad:** Media

---

### STORY-4.3: Create Partition

**Como** usuario
**Quiero** crear una nueva partición
**Para** instalar el sistema

**Acceptance Criteria:**
- [ ] Formulario: tamaño, tipo, mount point
- [ ] Validación de espacio
- [ ] Preview antes de aplicar

**Complejidad:** Alta

---

### STORY-4.4: Edit/Delete Partition

**Como** usuario
**Quiero** modificar particiones
**Para** ajustar la configuración

**Acceptance Criteria:**
- [ ] Editar tamaño/tipo
- [ ] Delete con confirmación
- [ ] Undo capability

**Complejidad:** Media

---

### STORY-4.5: Apply Partitions

**Como** usuario
**Quiero** aplicar cambios de particiones
**Para** preparar el disco

**Acceptance Criteria:**
- [ ] Confirmación múltiple (destructivo)
- [ ] Progress indication
- [ ] Error handling y recovery

**Complejidad:** Alta

---

### STORY-4.6: Partition Tests

**Como** desarrollador
**Quiero** tests de particiones
**Para** validar operaciones críticas

**Acceptance Criteria:**
- [ ] Tests con mock disk operations
- [ ] Edge cases cubiertos
- [ ] ≥80% coverage del módulo

**Complejidad:** Media

---

## Epic 5: Installation

**Objetivo:** Instalación del sistema (RF-04, RF-05)

### STORY-5.1: Pacstrap Installation

**Como** usuario
**Quiero** instalar el sistema base
**Para** tener Arch Linux funcionando

**Acceptance Criteria:**
- [ ] pacstrap wrapper
- [ ] Progress con百分比
- [ ] Log output visible
- [ ] Error handling

**Complejidad:** Alta

---

### STORY-5.2: Chroot Configuration

**Como** usuario
**Quiero** configurar el sistema instalado
**Para** personalizar la instalación

**Acceptance Criteria:**
- [ ] Entrar al chroot
- [ ] Configurar hostname, locale, etc.
- [ ] Aplicar configuración del usuario

**Complejidad:** Alta

---

### STORY-5.3: Bootloader Installation

**Como** usuario
**Quiero** instalar el bootloader
**Para** poder arrancar el sistema

**Acceptance Criteria:**
- [ ] GRUB installation
- [ ] UEFI y BIOS support
- [ ] Configuración automática

**Complejidad:** Alta

---

### STORY-5.4: User Creation

**Como** usuario
**Quiero** crear mi cuenta de usuario
**Para** usar el sistema

**Acceptance Criteria:**
- [ ] Formulario: username, password
- [ ] Añadir a wheel group
- [ ] Configurar sudo

**Complejidad:** Media

---

### STORY-5.5: Installation Progress

**Como** usuario
**Quiero** ver progreso de instalación
**Para** saber el estado

**Acceptance Criteria:**
- [ ] Progress bar
- [ ] Current step indicator
- [ ] Time estimate

**Complejidad:** Media

---

### STORY-5.6: Installation Error Recovery

**Como** usuario
**Quiero** recuperar errores de instalación
**Para** no perder progreso

**Acceptance Criteria:**
- [ ] Checkpoint system
- [ ] Resume from failure
- [ ] Rollback option

**Complejidad:** Alta

---

### STORY-5.7: Installation Tests

**Como** desarrollador
**Quiero** tests de instalación
**Para** validar proceso crítico

**Acceptance Criteria:**
- [ ] Mock pacstrap
- [ ] Mock chroot operations
- [ ] Integration tests

**Complejidad:** Alta

---

## Epic 6: Post-Installation

**Objetivo:** Configuración post-instalación (RF-08)

### STORY-6.1: Post-Install Menu

**Como** usuario
**Quiero** un menú de post-instalación
**Para** elegir configuraciones adicionales

**Acceptance Criteria:**
- [ ] Menú con opciones
- [ ] Profiles: base, hyprland, custom
- [ ] Selección múltiple

**Complejidad:** Baja

---

### STORY-6.2: Base Profile

**Como** usuario
**Quiero** instalar el profile base
**Para** tener sistema minimal funcional

**Acceptance Criteria:**
- [ ] Paquetes esenciales
- [ ] Configuraciones básicas
- [ ] Services habilitados

**Complejidad:** Media

---

### STORY-6.3: Hyprland Profile

**Como** usuario
**Quiero** instalar Hyprland
**Para** tener entorno gráfico

**Acceptance Criteria:**
- [ ] Hyprland y dependencias
- [ ] Configuración inicial
- [ ] Autostart setup

**Complejidad:** Media

---

### STORY-6.4: Utility Installation

**Como** usuario
**Quiero** instalar utilidades
**Para** herramientas adicionales

**Acceptance Criteria:**
- [ ] Plymouth, Remmina, etc.
- [ ] Dotfiles management
- [ ] Configuración automática

**Complejidad:** Media

---

### STORY-6.5: Completion Summary

**Como** usuario
**Quiero** ver un resumen final
**Para** saber qué se instaló

**Acceptance Criteria:**
- [ ] Resumen de instalación
- [ ] Log guardado
- [ ] Reboot option

**Complejidad:** Baja

---

## Summary

| Epic | Stories | Complejidad |
|------|---------|-------------|
| EPIC-1: Foundation | 5 | Baja/Media |
| EPIC-2: Menu Navigation | 4 | Baja/Media |
| EPIC-3: Pre-Installation | 5 | Baja/Media |
| EPIC-4: Partition Management | 6 | Media/Alta |
| EPIC-5: Installation | 7 | Alta |
| EPIC-6: Post-Installation | 5 | Baja/Media |
| **Total** | **32** | - |

---

*Epics & Stories generated via BMAD workflow*
