---
name: archlinux-install-tests
type: testing
created: 2026-02-23
priority: high
---

# Plan: Tests Automatizados para ArchLinux Install

## TL;DR

> Crear pruebas automatizadas para validar que el formulario TUI funcione correctamente,> 
> **Deliverables**:
> - Archivo de tests con coverage ≥80%
> - Todos los tests pasando
> **Estimated Effort**: Quick
> **Critical Path**: Tests → Fix → Re-run

---

## Context

El usuario reportó que el formulario no responde como se esperaba, especialmente los textbox.
Necesitamos pruebas automatizadas para detectar regresiones.

---

## Work Objectives

### Core Objective
Crear tests automatizados que validen:
1. Navegación del menú
2. Validación de campos del formulario (username, password)
3. Transiciones entre pantallas
4. Detección automática (timezone, network, disks)

### Concrete Deliverables
- `install_form_test.go` - Archivo de tests
- Coverage report

---

## TODOs

- [ ] 1. Crear archivo de test

  **What to do**:
  - Crear `install_form_test.go`
  - Importar testing y huh packages

  **Acceptance Criteria**:
  - [ ] File exists
  - [ ] Imports correct

---

- [ ] 2. Tests para validación de username

  **What to do**:
  - Test: empty string → error
  - Test: < 3 chars → error
  - Test: ≥ 3 chars → valid

  **Acceptance Criteria**:
  - [ ] Tests pass

---

- [ ] 3. Tests para validación de password

  **What to do**:
  - Test: empty → error
  - Test: < 6 chars → error
  - Test: ≥ 6 chars → valid

  **Acceptance Criteria**:
  - [ ] Tests pass

---

- [ ] 4. Tests para navegación del menú

  **What to do**:
  - Test: initial state is screen=menu
  - Test: j/down navigation
  - Test: k/up navigation
  - Test: boundaries (can't go past min/max)

  **Acceptance Criteria**:
  - [ ] Tests pass

---

- [ ] 5. Tests para transiciones de pantalla

  **What to do**:
  - Test: Enter from menu → form screen
  - Test: Escape from form → menu screen
  - Test: Enter on confirm → installing screen

  **Acceptance Criteria**:
  - [ ] Tests pass

---

- [ ] 6. Tests para detección automática

  **What to do**:
  - Test: detectTimezone() returns non-empty
  - Test: getNetworkInterfaces() returns non-empty
  - Test: getDisks() returns non-empty

  **Acceptance Criteria**:
  - [ ] Tests pass

---

- [ ] 7. Ejecutar tests y generar coverage

  **What to do**:
  - Run: go test -v
  - Run: go test -cover
  - Verify: ≥80% coverage

  **Commands**:
  ```bash
  cd /workspace/ArchLinux_install
  go test -v -cover
  ```

  **Acceptance Criteria**:
  - [ ] All tests pass
  - [ ] Coverage ≥80%

---

## Success Criteria

### Verification Commands
```bash
cd /workspace/ArchLinux_install
go test -v -cover
```

### Final Checklist
- [ ] Tests file created
- [ ] All tests pass
- [ ] Coverage ≥80%
