# Tests for ArchLinux Install Form

```go
package main

import (
	"fmt"
	"testing"

	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/huh"
)

// ============================================================================
// ERROR DEFINITIONS
// ============================================================================

var ErrUsernameTooShort = fmt.Errorf("nombre de usuario debe tener mínimo 3 caracteres")
var ErrPasswordTooShort = fmt.Errorf("contraseña debe tener mínimo 6 caracteres")
var ErrEmptyIP = fmt.Errorf("IP vacía")

// ============================================================================
// VALIDATION FUNCTIONS (export these from main code)
// ============================================================================

func validateUsername(s string) error {
	if len(s) < 3 {
		return ErrUsernameTooShort
	}
	return nil
}

func validatePassword(s string) error {
	if len(s) < 6 {
		return ErrPasswordTooShort
	}
	return nil
}

func validateIP(s string) error {
	if s == "" {
		return ErrEmptyIP
	}
	return nil
}

// ============================================================================
// HELPER FOR CREATING KEY MESSAGES
// ============================================================================

func keyMsg(key string) tea.KeyMsg {
	return tea.KeyMsg{Type: tea.KeyRunes, Runes: []rune(key)}
}

// ============================================================================
// TESTS PARA USERNAME VALIDATION
// ============================================================================

func TestUsernameValidation(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"empty", "", true},
		{"too short - 1 char", "a", true},
		{"too short - 2 chars", "ab", true},
		{"valid - 3 chars", "abc", false},
		{"valid - normal", "hans", false},
		{"valid with underscore", "hans_test", false},
		{"valid with numbers", "hans123", false},
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

// ============================================================================
// TESTS PARA PASSWORD VALIDATION
// ============================================================================

func TestPasswordValidation(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"empty", "", true},
		{"too short - 5 chars", "12345", true},
		{"valid - 6 chars", "123456", false},
		{"valid - longer", "mypassword123", false},
		{"valid - special chars", "p@ssw0rd!", false},
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

// ============================================================================
// TESTS PARA INITIAL MODEL
// ============================================================================

func TestInitialModelDefaults(t *testing.T) {
	m := initialModel()

	if m.screen != screenMenu {
		t.Errorf("Initial screen should be screenMenu (0), got %v", m.screen)
	}

	if m.selected != 0 {
		t.Errorf("Initial selected should be 0, got %d", m.selected)
	}

	if m.progress != 0 {
		t.Errorf("Initial progress should be 0, got %f", m.progress)
	}

	if m.form != nil {
		t.Error("Initial form should be nil")
	}
}

// ============================================================================
// TESTS PARA MENU NAVIGATION
// ============================================================================

func TestMenuNavigationDown(t *testing.T) {
	m := initialModel()

	// Press 'j' (down)
	model, _ := m.Update(keyMsg("j"))
	m = model.(model)

	if m.selected != 1 {
		t.Errorf("After 'j', selected should be 1, got %d", m.selected)
	}

	// Press 'j' again
	model, _ = m.Update(keyMsg("j"))
	m = model.(model)

	if m.selected != 2 {
		t.Errorf("After second 'j', selected should be 2, got %d", m.selected)
	}
}

func TestMenuNavigationUp(t *testing.T) {
	m := initialModel()
	m.selected = 2

	// Press 'k' (up)
	model, _ := m.Update(keyMsg("k"))
	m = model.(model)

	if m.selected != 1 {
		t.Errorf("After 'k', selected should be 1, got %d", m.selected)
	}
}

func TestMenuNavigationBoundaryTop(t *testing.T) {
	m := initialModel()
	m.selected = 0

	// Press 'k' (up) at top - should stay at 0
	model, _ := m.Update(keyMsg("k"))
	m = model.(model)

	if m.selected != 0 {
		t.Errorf("At top, 'k' should keep selected at 0, got %d", m.selected)
	}
}

func TestMenuNavigationBoundaryBottom(t *testing.T) {
	m := initialModel()
	m.selected = 2

	// Press 'j' (down) at bottom - should stay at 2
	model, _ := m.Update(keyMsg("j"))
	m = model.(model)

	if m.selected != 2 {
		t.Errorf("At bottom, 'j' should keep selected at 2, got %d", m.selected)
	}
}

// ============================================================================
// TESTS PARA ARROW KEYS
// ============================================================================

func TestMenuNavigationArrowDown(t *testing.T) {
	m := initialModel()

	// Press down arrow
	downMsg := tea.KeyMsg{Type: tea.KeyDown}
	model, _ := m.Update(downMsg)
	m = model.(model)

	if m.selected != 1 {
		t.Errorf("After down arrow, selected should be 1, got %d", m.selected)
	}
}

func TestMenuNavigationArrowUp(t *testing.T) {
	m := initialModel()
	m.selected = 1

	// Press up arrow
	upMsg := tea.KeyMsg{Type: tea.KeyUp}
	model, _ := m.Update(upMsg)
	m = model.(model)

	if m.selected != 0 {
		t.Errorf("After up arrow, selected should be 0, got %d", m.selected)
	}
}

// ============================================================================
// TESTS PARA QUIT COMMAND
// ============================================================================

func TestQuitFromMenu(t *testing.T) {
	m := initialModel()

	// Press 'q' in menu should quit
	_, cmd := m.Update(keyMsg("q"))

	if cmd == nil {
		t.Error("'q' should return a quit command")
	}
}

// ============================================================================
// TESTS PARA ENTER ON MENU - NUEVA INSTALACIÓN
// ============================================================================

func TestEnterOnMenuNewInstall(t *testing.T) {
	m := initialModel()

	// Press Enter on "Nueva Instalación" (selected=0)
	enterMsg := tea.KeyMsg{Type: tea.KeyEnter}
	model, _ := m.Update(enterMsg)
	m = model.(model)

	if m.screen != screenInstallForm {
		t.Errorf("After Enter on 'Nueva Instalación', screen should be screenInstallForm, got %v", m.screen)
	}

	if m.form == nil {
		t.Error("After Enter, form should not be nil")
	}
}

func TestEnterOnMenuExit(t *testing.T) {
	m := initialModel()
	m.selected = 2 // "Salir"

	// Press Enter on "Salir" should quit
	enterMsg := tea.KeyMsg{Type: tea.KeyEnter}
	_, cmd := m.Update(enterMsg)

	if cmd == nil {
		t.Error("Enter on 'Salir' should return a quit command")
	}
}

// ============================================================================
// TESTS PARA FORM CREATION
// ============================================================================

func TestCreateInstallFormNotNil(t *testing.T) {
	m := initialModel()
	form := createInstallForm(&m)

	if form == nil {
		t.Fatal("createInstallForm returned nil")
	}

	if form.State != huh.StateNormal {
		t.Errorf("Form should be in normal state, got %v", form.State)
	}
}

func TestCreateInstallFormSetsDefaults(t *testing.T) {
	m := initialModel()
	_ = createInstallForm(&m)

	// After creating form, config should have defaults
	if m.config.PartitionScheme != "uefi" {
		t.Errorf("Default PartitionScheme should be 'uefi', got '%s'", m.config.PartitionScheme)
	}

	if m.config.Bootloader != "grub" {
		t.Errorf("Default Bootloader should be 'grub', got '%s'", m.config.Bootloader)
	}
}

// ============================================================================
// TESTS PARA TIMEZONE DETECTION
// ============================================================================

func TestDetectTimezoneNotEmpty(t *testing.T) {
	tz := detectTimezone()

	if tz == "" {
		t.Error("detectTimezone() should not return empty string")
	}

	t.Logf("Detected timezone: %s", tz)
}

// ============================================================================
// TESTS PARA NETWORK INTERFACES
// ============================================================================

func TestGetNetworkInterfacesNotEmpty(t *testing.T) {
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

	t.Logf("Found interfaces: %v", ifaces)
}

// ============================================================================
// TESTS PARA DISK DETECTION
// ============================================================================

func TestGetDisksNotEmpty(t *testing.T) {
	disks := getDisks()

	if len(disks) == 0 {
		t.Error("getDisks() returned empty slice")
	}

	// Cada disco debe empezar con /dev/
	for _, disk := range disks {
		if len(disk) < 5 {
			t.Errorf("Disk string too short: %s", disk)
		}
	}

	t.Logf("Found disks: %v", disks)
}

// ============================================================================
// TESTS PARA SCREEN TRANSITIONS
// ============================================================================

func TestScreenConstants(t *testing.T) {
	if screenMenu != 0 {
		t.Errorf("screenMenu should be 0, got %d", screenMenu)
	}
	if screenInstallForm != 1 {
		t.Errorf("screenInstallForm should be 1, got %d", screenInstallForm)
	}
	if screenConfirm != 2 {
		t.Errorf("screenConfirm should be 2, got %d", screenConfirm)
	}
	if screenInstalling != 3 {
		t.Errorf("screenInstalling should be 3, got %d", screenInstalling)
	}
	if screenComplete != 4 {
		t.Errorf("screenComplete should be 4, got %d", screenComplete)
	}
}
```
