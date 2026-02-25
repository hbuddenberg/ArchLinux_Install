# test_form.go - Pruebas automatizadas

```go
package main

import (
	"testing"
)

// ============================================================================
// TESTS PARA CONFIG
// ============================================================================

func TestConfigDefaults(t *testing.T) {
	config := Config{
		PartitionScheme: "uefi",
		Bootloader:      "grub",
	}

	if config.PartitionScheme != "uefi" {
		t.Errorf("Expected PartitionScheme 'uefi', got '%s'", config.PartitionScheme)
	}

	if config.Bootloader != "grub" {
		t.Errorf("Expected Bootloader 'grub', got '%s'", config.Bootloader)
	}
}

// ============================================================================
// TESTS PARA VALIDACIÓN DE USERNAME
// ============================================================================

func TestUsernameValidation(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"empty", "", true},
		{"too short", "ab", true},
		{"valid", "hans", false},
		{"valid with underscore", "hans_test", false},
		{"valid with numbers", "hans123", false},
		{"minimum valid", "abc", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := validateUsername(tt.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("validateUsername(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
			}
		})
	}
}

func validateUsername(s string) error {
	if len(s) < 3 {
		return ErrUsernameTooShort
	}
	return nil
}

// ============================================================================
// TESTS PARA VALIDACIÓN DE PASSWORD
// ============================================================================

func TestPasswordValidation(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"empty", "", true},
		{"too short", "12345", true},
		{"valid", "123456", false},
		{"valid longer", "mypassword123", false},
		{"minimum valid", "123456", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := validatePassword(tt.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("validatePassword(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
			}
		})
	}
}

func validatePassword(s string) error {
	if len(s) < 6 {
		return ErrPasswordTooShort
	}
	return nil
}

// ============================================================================
// TESTS PARA VALIDACIÓN DE IP
// ============================================================================

func TestIPValidation(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"empty", "", true},
		{"invalid format", "192.168.1", true},
		{"invalid segment", "192.168.1.300", true},
		{"valid", "192.168.1.100", false},
		{"localhost", "127.0.0.1", false},
		{"with letters", "192.168.1.abc", true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := validateIP(tt.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("validateIP(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
			}
		})
	}
}

func validateIP(s string) error {
	if s == "" {
		return ErrEmptyIP
	}
	return nil
}

// ============================================================================
// TESTS PARA DETECCIÓN DE TIMEZONE
// ============================================================================

func TestTimezoneDetection(t *testing.T) {
	// Test que la función no retorna vacío
	tz := detectTimezone()
	if tz == "" {
		t.Error("detectTimezone() returned empty string")
	}
}

// ============================================================================
// TESTS PARA NETWORK INTERFACES
// ============================================================================

func TestGetNetworkInterfaces(t *testing.T) {
	ifaces := getNetworkInterfaces()
	if len(ifaces) == 0 {
		t.Error("getNetworkInterfaces() returned empty slice")
	}
	
	// No debe incluir 'lo'
	for _, iface := range ifaces {
		if iface == "lo" {
			t.Error("getNetworkInterfaces() should not include 'lo'")
		}
	}
}

// ============================================================================
// TESTS PARA DISK DETECTION
// ============================================================================

func TestGetDisks(t *testing.T) {
	disks := getDisks()
	if len(disks) == 0 {
		t.Error("getDisks() returned empty slice")
	}
	
	// Cada disco debe empezar con /dev/
	for _, disk := range disks {
		if len(disk) < 5 || disk[:5] != "/dev/" {
			t.Errorf("Invalid disk format: %s", disk)
		}
	}
}

// ============================================================================
// TESTS PARA SCREEN TRANSITIONS
// ============================================================================

func TestScreenTransitions(t *testing.T) {
	m := initialModel()
	
	// Verificar estado inicial
	if m.screen != screenMenu {
		t.Errorf("Initial screen should be screenMenu, got %v", m.screen)
	}
	
	// Verificar que selected empieza en 0
	if m.selected != 0 {
		t.Errorf("Initial selected should be 0, got %d", m.selected)
	}
}

// ============================================================================
// TESTS PARA MODEL UPDATE - MENU NAVIGATION
// ============================================================================

func TestMenuNavigation(t *testing.T) {
	m := initialModel()
	
	// Test navegación hacia abajo
	m.Update(keyMsg("down"))
	if m.selected != 1 {
		t.Errorf("After down, selected should be 1, got %d", m.selected)
	}
	
	m.Update(keyMsg("down"))
	if m.selected != 2 {
		t.Errorf("After second down, selected should be 2, got %d", m.selected)
	}
	
	// No debe pasar del máximo
	m.Update(keyMsg("down"))
	if m.selected != 2 {
		t.Errorf("Selected should stay at 2, got %d", m.selected)
	}
	
	// Test navegación hacia arriba
	m.Update(keyMsg("up"))
	if m.selected != 1 {
		t.Errorf("After up, selected should be 1, got %d", m.selected)
	}
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

var (
	ErrUsernameTooShort = fmt.Errorf("mínimo 3 caracteres")
	ErrPasswordTooShort = fmt.Errorf("mínimo 6 caracteres")
	ErrEmptyIP          = fmt.Errorf("IP vacía")
)

func keyMsg(key string) tea.KeyMsg {
	return tea.KeyMsg{Type: tea.KeyRunes, Runes: []rune(key)}
}
```

```go
package main

import (
	"fmt"
	"testing"

	"github.com/charmbracelet/bubbletea"
)
```
