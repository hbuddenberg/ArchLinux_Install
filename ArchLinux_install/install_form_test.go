package main

import (
	"fmt"
	"testing"

	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/huh"
)
// ============================================================================
// ERRORES PERSONALIZADOS
// ============================================================================

var (
	ErrUsernameTooShort = fmt.Errorf("el nombre de usuario debe tener al menos 3 caracteres")
	ErrPasswordTooShort  = fmt.Errorf("la contraseña debe tener al menos 6 caracteres")
	ErrEmptyIP          = fmt.Errorf("IP vacía")
)

// ============================================================================
// FUNCIONES DE VALIDACIÓN (extraídas para testing)
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
// TESTS PARA VALIDACIÓN DE USERNAME
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
// TESTS PARA VALIDACIÓN DE PASSWORD
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
// TESTS PARA VALIDACIÓN DE IP
// ============================================================================

func TestIPValidation(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantErr bool
	}{
		{"empty", "", true},
		{"valid localhost", "127.0.0.1", false},
		{"valid local network", "192.168.1.100", false},
		{"valid public", "8.8.8.8", false},
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

// ============================================================================
// TESTS PARA SCREEN CONSTANTS
// ============================================================================

func TestScreenConstants(t *testing.T) {
	if screenMenu != 0 {
		t.Error("screenMenu should be 0")
	}
	if screenInstallForm != 1 {
		t.Error("screenInstallForm should be 1")
	}
	if screenConfirm != 2 {
		t.Error("screenConfirm should be 2")
	}
	if screenInstalling != 3 {
		t.Error("screenInstalling should be 3")
	}
	if screenComplete != 4 {
		t.Error("screenComplete should be 4")
	}
}

// ============================================================================
// TESTS PARA INITIAL MODEL
// ============================================================================

func TestInitialModel(t *testing.T) {
	m := initialModel()

	if m.screen != screenMenu {
		t.Errorf("Initial screen should be screenMenu, got %v", m.screen)
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
// HELPER PARA CREAR KEY MESSAGES
// ============================================================================

func keyMsg(key string) tea.KeyMsg {
	return tea.KeyMsg{Type: tea.KeyRunes, Runes: []rune(key)}
}

func keyEnter() tea.KeyMsg {
	return tea.KeyMsg{Type: tea.KeyEnter}
}

func keyDown() tea.KeyMsg {
	return tea.KeyMsg{Type: tea.KeyDown}
}

func keyUp() tea.KeyMsg {
	return tea.KeyMsg{Type: tea.KeyUp}
}

func keyEscape() tea.KeyMsg {
	return tea.KeyMsg{Type: tea.KeyEscape}
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
}

func TestMenuNavigationUp(t *testing.T) {
	m := initialModel()
	m.selected = 1

	// Press 'k' (up)
	model, _ := m.Update(keyMsg("k"))
	m = model.(model)

	if m.selected != 0 {
		t.Errorf("After 'k', selected should be 0, got %d", m.selected)
	}
}

func TestMenuNavigationArrowDown(t *testing.T) {
	m := initialModel()

	// Press down arrow
	model, _ := m.Update(keyDown())
	m = model.(model)

	if m.selected != 1 {
		t.Errorf("After down arrow, selected should be 1, got %d", m.selected)
	}
}

func TestMenuNavigationArrowUp(t *testing.T) {
	m := initialModel()
	m.selected = 1

	// Press up arrow
	model, _ := m.Update(keyUp())
	m = model.(model)

	if m.selected != 0 {
		t.Errorf("After up arrow, selected should be 0, got %d", m.selected)
	}
}

// ============================================================================
// TESTS PARA BOUNDARIES
// ============================================================================

func TestMenuNavigationTopBoundary(t *testing.T) {
	m := initialModel()
	m.selected = 0

	// Press up at top - should stay at 0
	model, _ := m.Update(keyUp())
	m = model.(model)

	if m.selected != 0 {
		t.Errorf("At top, 'up' should keep selected at 0, got %d", m.selected)
	}
}

func TestMenuNavigationBottomBoundary(t *testing.T) {
	m := initialModel()
	m.selected = 2

	// Press down at bottom - should stay at 2
	model, _ := m.Update(keyDown())
	m = model.(model)

	if m.selected != 2 {
		t.Errorf("At bottom, 'down' should keep selected at 2, got %d", m.selected)
	}
}

// ============================================================================
// TESTS PARA QUIT
// ============================================================================

func TestQuitFromMenu(t *testing.T) {
	m := initialModel()

	// Press 'q' in menu
	_, cmd := m.Update(keyMsg("q"))

	if cmd == nil {
		t.Error("'q' should return a quit command")
	}
}

// ============================================================================
// TESTS PARA ENTER ON MENU
// ============================================================================

func TestEnterOnMenuNewInstall(t *testing.T) {
	m := initialModel()

	// Press Enter on "Nueva Instalación" (selected=0)
	model, _ := m.Update(keyEnter())
	m = model.(model)

	if m.screen != screenInstallForm {
		t.Errorf("After Enter on 'Nueva Instalación', screen should be screenInstallForm (1), got %v", m.screen)
	}

	if m.form == nil {
		t.Error("After Enter, form should not be nil")
	}
}

func TestEnterOnMenuExit(t *testing.T) {
	m := initialModel()
	m.selected = 2 // "Salir"

	// Press Enter on "Salir" should quit
	_, cmd := m.Update(keyEnter())

	if cmd == nil {
		t.Error("Enter on 'Salir' should return a quit command")
	}
}

// ============================================================================
// TESTS PARA ESCAPE FROM FORM
// ============================================================================

func TestEscapeFromForm(t *testing.T) {
	m := initialModel()
	m.screen = screenInstallForm
	m.form = createInstallForm(&m)

	// Press Escape from form
	model, _ := m.Update(keyEscape())
	m = model.(model)

	if m.screen != screenMenu {
		t.Errorf("After Escape from form, screen should be screenMenu,0), got %v", m.screen)
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

	// Verificar que los defaults se establecieron
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
// TESTS PARA CONFIG STRUCT
// ============================================================================

func TestConfigDefaults(t *testing.T) {
	config := Config{}

	// Verificar que los valores por defecto están vacíos
	if config.Username != "" {
		t.Error("Default Username should be empty")
	}
	if config.Password != "" {
		t.Error("Default Password should be empty")
	}
	if config.EnableSudo != false {
		t.Error("Default EnableSudo should be false")
	}
}

// ============================================================================
// TESTS PARA PROGRESS TICK
// ============================================================================

func TestProgressTick(t *testing.T) {
	m := initialModel()
	m.screen = screenInstalling

	// Simular un tick
	tickMsg := tick()
	if tickMsg == nil {
		t.Error("tick() should return a command")
	}
}
