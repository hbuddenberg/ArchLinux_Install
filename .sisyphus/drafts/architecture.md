---
stepsCompleted:
  - step-01-init
  - step-02-context
  - step-03-starter
  - step-04-decisions
  - step-05-patterns
  - step-06-structure
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
workflowType: 'architecture'
project_name: 'ArchLinux Install'
user_name: 'Hans'
date: '2026-02-23'
---

# Architecture Decision Document - ArchLinux Install

## 1. Project Context Analysis

### Requirements Overview

**Functional Requirements (8 total):**

| ID | Requisito | Módulo |
|----|-----------|--------|
| RF-01 | Menú principal con navegación por módulos | menu |
| RF-02 | Selección de zona horaria | timezone |
| RF-03 | Gestión de particiones (crear, editar, eliminar) | partitions |
| RF-04 | Instalación del sistema base Arch Linux | install |
| RF-05 | Configuración de bootloader | bootloader |
| RF-06 | Validación de conexión a internet | network |
| RF-07 | Actualización de paquetes | pacman |
| RF-08 | Módulo de post-instalación | postinstall |

**Non-Functional Requirements:**

| ID | Requisito | Target |
|----|-----------|--------|
| RNF-01 | Tamaño del ejecutable | < 30 MB |
| RNF-02 | Cobertura de pruebas | ≥ 80% |
| RNF-03 | Tiempo de instalación | < 15 minutos |
| RNF-04 | Compatibilidad | Arch Linux latest |
| RNF-05 | Interfaz | TUI sin dependencias gráficas |

### Technical Constraints

- **Platform**: x86_64, UEFI + BIOS legacy
- **Privileges**: Root required
- **Filesystems**: ext4, btrfs, xfs, f2fs
- **Dependencies**: pacman, archinstall (optional)

---

## 2. Core Architectural Decisions

### Decision 1: State Management

**Pattern:** Bubble Tea MVU (Model-View-Update)

```go
type Model struct {
    state       InstallationState
    config      Config
    currentStep int
    
    // Component models
    menu       MenuModel
    timezone   TimezoneModel
    partitions PartitionModel
    installer  InstallerModel
    
    err error
}

type InstallationState int

const (
    StateMenu InstallationState = iota
    StateTimezone
    StatePartitions
    StateInstalling
    StateBootloader
    StateComplete
    StateError
)
```

**Rationale:** Native to Bubble Tea, single source of truth, serializable for recovery.

---

### Decision 2: Error Handling

**Pattern:** Typed Errors with Recovery Strategies

```go
type InstallError struct {
    Code     ErrorCode
    Message  string
    Cause    error
    Recovery RecoveryStrategy
}

type ErrorCode int

const (
    ErrNetworkUnavailable ErrorCode = iota
    ErrPartitionFailed
    ErrInstallationFailed
    ErrBootloaderFailed
    ErrPermissionDenied
)

type RecoveryStrategy int

const (
    RecoveryAbort RecoveryStrategy = iota
    RecoveryRetry
    RecoverySkip
    RecoveryManual
)
```

**Rationale:** Precise handling with user guidance for recovery.

---

### Decision 3: Command Execution

**Pattern:** Interface-based with Mocking

```go
type CommandRunner interface {
    Run(name string, args ...string) (*CommandResult, error)
    RunInteractive(name string, args ...string) error
}

type SafeRunner struct {
    timeout time.Duration
}

func (r *SafeRunner) Run(name string, args ...string) (*CommandResult, error) {
    ctx, cancel := context.WithTimeout(context.Background(), r.timeout)
    defer cancel()
    cmd := exec.CommandContext(ctx, name, args...)
    // Execute with timeout and output capture
}
```

**Rationale:** Testable without real commands, timeout support.

---

### Decision 4: Configuration

**Pattern:** JSON with Validation

```go
type Config struct {
    Version     int               `json:"version"`
    Timezone    string            `json:"timezone"`
    Partitions  []Partition       `json:"partitions"`
    Bootloader  BootloaderConfig  `json:"bootloader"`
    PostInstall PostInstallConfig `json:"postInstall"`
}

func (c *Config) Validate() error {
    // Validate configuration consistency
}
```

**Rationale:** Human-readable, stdlib support, compatible with existing config.

---

### Decision 5: Module Communication

**Pattern:** Tea Message Passing

```go
type ProgressMsg struct {
    Current int
    Total   int
    Message string
}

type CompleteMsg struct {
    Success bool
    Error   error
}
```

**Rationale:** Native Bubble Tea, type-safe, clear data flow.

---

### Decision 6: Testing Strategy

**Pattern:** Table-Driven with Mocking

```go
func TestPartitionCreate(t *testing.T) {
    tests := []struct {
        name    string
        config  PartitionConfig
        wantErr bool
    }{
        {"valid partition", PartitionConfig{Size: "10G"}, false},
        {"invalid size", PartitionConfig{Size: "invalid"}, true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // Test with mock runner
        })
    }
}
```

**Rationale:** Go standard, achieves ≥80% coverage.

---

### Decision 7: Privilege Management

**Pattern:** Root Validation at Startup

```go
func ValidateRootAccess() error {
    if os.Geteuid() != 0 {
        return fmt.Errorf("this installer requires root privileges")
    }
    return nil
}
```

**Rationale:** Fail-fast, clear messaging.

---

## 3. Project Structure

```
ArchLinux_install/
├── cmd/
│   └── archinstall/
│       └── main.go
├── internal/
│   ├── app/
│   │   ├── app.go
│   │   ├── model.go
│   │   └── messages.go
│   ├── config/
│   │   ├── config.go
│   │   ├── load.go
│   │   └── validate.go
│   ├── modules/
│   │   ├── menu/
│   │   │   ├── model.go
│   │   │   ├── view.go
│   │   │   └── update.go
│   │   ├── timezone/
│   │   │   ├── model.go
│   │   │   ├── view.go
│   │   │   ├── update.go
│   │   │   └── data.go
│   │   ├── partitions/
│   │   │   ├── model.go
│   │   │   ├── view.go
│   │   │   ├── update.go
│   │   │   └── operations.go
│   │   ├── install/
│   │   │   ├── model.go
│   │   │   ├── view.go
│   │   │   ├── update.go
│   │   │   └── pacstrap.go
│   │   ├── bootloader/
│   │   │   ├── model.go
│   │   │   ├── view.go
│   │   │   ├── update.go
│   │   │   └── grub.go
│   │   ├── network/
│   │   │   ├── model.go
│   │   │   ├── view.go
│   │   │   └── validate.go
│   │   ├── pacman/
│   │   │   ├── model.go
│   │   │   ├── view.go
│   │   │   └── operations.go
│   │   └── postinstall/
│   │       ├── model.go
│   │       ├── view.go
│   │       └── profiles.go
│   ├── ui/
│   │   ├── styles.go
│   │   ├── keys.go
│   │   └── components/
│   │       ├── progress.go
│   │       └── confirm.go
│   ├── system/
│   │   ├── command/
│   │   │   ├── runner.go
│   │   │   ├── safe.go
│   │   │   └── mock.go
│   │   ├── partition/
│   │   │   ├── manager.go
│   │   │   └── types.go
│   │   ├── pacman/
│   │   │   └── operations.go
│   │   └── root/
│   │       └── validate.go
│   └── util/
│       ├── errors.go
│       └── logger.go
├── go.mod
├── go.sum
├── Makefile
└── README.md
```

---

## 4. Requirements to Module Mapping

| Requirement | Module | Files |
|-------------|--------|-------|
| RF-01: Menú Principal | modules/menu/ | model.go, view.go, update.go |
| RF-02: Zona Horaria | modules/timezone/ | model.go, view.go, data.go |
| RF-03: Particiones | modules/partitions/ + system/partition/ | model.go, operations.go |
| RF-04: Instalación Base | modules/install/ + system/pacman/ | model.go, pacstrap.go |
| RF-05: Bootloader | modules/bootloader/ | model.go, grub.go |
| RF-06: Validación Internet | modules/network/ | model.go, validate.go |
| RF-07: Actualizar Paquetes | modules/pacman/ | model.go, operations.go |
| RF-08: Post-Instalación | modules/postinstall/ | model.go, profiles.go |

---

## 5. Dependencies

```go
// go.mod
module github.com/HansBuddenbergBlamey/ArchLinux_install

go 1.21

require (
    github.com/charmbracelet/bubbletea v0.25.0
    github.com/charmbracelet/huh v0.3.0
    github.com/charmbracelet/lipgloss v0.9.1
)
```

---

## 6. Risk Mitigation

| Risk | Mitigation | Priority |
|------|------------|----------|
| Partition operations destructive | Confirmation dialogs, dry-run mode | High |
| Installation failure recovery | State checkpoints, rollback | Critical |
| Network interruption | Retry logic, resume capability | Medium |
| Root privilege misuse | Validation, audit logging | High |
| Binary size > 30 MB | Static compilation, UPX compression | Medium |

---

## 7. Implementation Sequence

**Phase 1: Foundation**
1. Initialize Go module
2. Set up Bubble Tea scaffold
3. Implement command execution layer
4. Create configuration system

**Phase 2: Core Modules**
1. Menu navigation
2. Timezone selection
3. Partition management
4. Installation logic
5. Bootloader configuration

**Phase 3: Polish**
1. Network validation
2. Pacman updates
3. Post-install profiles
4. Progress reporting
5. Comprehensive testing

---

*Architecture document generated via BMAD create-architecture workflow*
