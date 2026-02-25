---
name: archlinux-install-prototype
type: implementation
status: completed
created: 2026-02-23
completed: 2026-02-23
priority: high
---

# Plan: Prototipo Visual - Menú Principal

## TL;DR

> Crear un prototipo funcional del menú principal de ArchLinux Install usando Bubble Tea + Huh + Lipgloss.
> 
> **Entrega**: Aplicación TUI ejecutable que muestra el menú principal con el logo de Arch
> 
> **Objetivo**: Verificar el look & feel antes de implementar toda la funcionalidad

---

## Context

### Request del Usuario
El usuario quiere una primera aproximación del menú principal:
- Usar herramientas de Charm (Bubble Tea, Huh, Lipgloss)
- Debe verse "precioso" (beautiful)
- Logo desde docs/logo.txt
- Formulario con Tab navigation

### Diseño Aprobado
- Logo Arch completo en la parte superior
- Menú con opciones principales
- Navegación por teclado

---

## Work Objectives

### Core Objective
Crear un prototipo ejecutable del menú principal que muestre:
1. Logo de Arch Linux formateado
2. Menú de navegación principal
3. Estilos con Lipgloss (colores Arch)
4. Navegación funcional (arrows, enter, q to quit)

### Concrete Deliverables
- Archivo Go con el prototipo
- Ejecutable compilado
- Captura de pantalla del resultado

---

## Execution Strategy

### Wave 1: Setup + Main Menu Prototype

**Tareas:**
1.1 Inicializar proyecto Go con dependencias Charm
1.2 Crear main.go con Bubble Tea básico
1.3 Implementar logo formateado
1.4 Crear menú de navegación
1.5 Aplicar estilos Lipgloss (colores Arch)
1.6 Compilar y probar

---

## TODOs

- [ ] 1.1 Inicializar proyecto Go

  **What to do**:
  - Crear directorio del proyecto
  - Inicializar go.mod
  - Instalar dependencias: bubbletea, huh, lipgloss

  **Commands**:
  ```bash
  mkdir -p ArchLinux_install
  cd ArchLinux_install
  go mod init github.com/HansBuddenbergBlamey/ArchLinux_install
  go get github.com/charmbracelet/bubbletea@latest
  go get github.com/charmbracelet/huh@latest
  go get github.com/charmbracelet/lipgloss@latest
  ```

  **Acceptance Criteria**:
  - [ ] go.mod creado
  - [ ] Dependencias instaladas

---

- [ ] 1.2 Crear main.go básico

  **What to do**:
  - Crear archivo main.go
  - Configurar Bubble Tea app básica
  - Agregar modelo vacío para testing

  **References**:
  - Docs: https://github.com/charmbracelet/bubbletea

  **Acceptance Criteria**:
  - [ ] main.go compila
  - [ ] App ejecuta sin errores

---

- [ ] 1.3 Implementar Logo

  **What to do**:
  - Leer docs/logo.txt
  - Convertir a formato Lipgloss
  - Aplicar colores Arch (#1793D1, #00FFFF)

  **References**:
  - Logo: docs/logo.txt

  **Acceptance Criteria**:
  - [ ] Logo visible en terminal
  - [ ] Colores correctos

---

- [ ] 1.4 Crear Menú de Navegación

  **What to do**:
  - Crear lista de opciones:
    - Nueva Instalación
    - Utilidades
    - Salir
  - Implementar navegación con arrows

  **Acceptance Criteria**:
  - [ ] Opciones visibles
  - [ ] Navegación funcional

---

- [ ] 1.5 Aplicar Estilos Lipgloss

  **What to do**:
  - Definir color palette:
    - Arch Blue: #1793D1
    - Arch Cyan: #00FFFF
    - Background: #0D1B2A (dark)
  - Estilos para:
    - Título
    - Opciones de menú
    - Selection highlight

  **Acceptance Criteria**:
  - [ ] Estilos aplicados
  - [ ] Look & feel profesional

---

- [ ] 1.6 Compilar y Probar

  **What to do**:
  - Compilar: go build -o archinstall
  - Ejecutar y verificar
  - Tomar screenshot

  **Commands**:
  ```bash
  go build -o archinstall
  ./archinstall
  ```

  **Acceptance Criteria**:
  - [ ] Compila sin errores
  - [ ] Ejecuta correctamente
  - [ ] Se ve "precioso"

---

## Success Criteria

### Verification
```bash
go build -o archinstall && ./archinstall
# Expected: Menu visual con logo y colores Arch
```

### Final Checklist
- [ ] Proyecto Go inicializado
- [ ] Dependencias Charm instaladas
- [ ] Logo formateado con colores
- [ ] Menú de navegación funcional
- [ ] Est Lipgloss aplicados
- [ ] Prototipo ejecutable
