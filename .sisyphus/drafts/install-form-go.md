# install-form.go code

```go
package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"

	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/huh"
	"github.com/charmbracelet/lipgloss"
)

// ============================================================================
// ESTILOS
// ============================================================================

var (
	archBlue   = lipgloss.Color("#1793D1")
	archCyan   = lipgloss.Color("#00FFFF")
	archWhite  = lipgloss.Color("#FFFFFF")
	selectedBg = lipgloss.Color("#1793D1")
	darkBg     = lipgloss.Color("#0D1B2A")

	titleStyle = lipgloss.NewStyle().
			Foreground(archCyan).
			Bold(true).
			Padding(1, 0).
			Align(lipgloss.Center)

	logoStyle = lipgloss.NewStyle().
			Foreground(archBlue)

	menuStyle = lipgloss.NewStyle().
			Foreground(archWhite).
			Padding(0, 4)

	selectedStyle = lipgloss.NewStyle().
			Foreground(archWhite).
			Background(selectedBg).
			Bold(true).
			Padding(0, 4)

	helpStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#666666")).
			Padding(1, 0)

	boxStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(archBlue).
			Padding(1, 2).
			Margin(1, 0)

	progressStyle = lipgloss.NewStyle().
			Foreground(archCyan).
			Bold(true)

	successStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#00FF00")).
			Bold(true)

	errorStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#FF0000"))
)

// ============================================================================
// CONFIGURACIÓN
// ============================================================================

type Config struct {
	Username     string
	Password     string
	EnableSudo   bool
	TimezoneAuto bool
	Timezone     string
	NetworkIface string
	Disk         string
	PartitionScheme string
	Bootloader   string
}

// ============================================================================
// PANTALLAS
// ============================================================================

type screen int

const (
	screenMenu screen = iota
	screenInstallForm
	screenConfirm
	screenInstalling
	screenComplete
)

// ============================================================================
// MODELO
// ============================================================================

type model struct {
	screen      screen
	selected    int
	config      Config
	form        *huh.Form
	progress    float64
	progressMsg string
	width       int
	height      int
	err         error
}

func initialModel() model {
	return model{
		screen:   screenMenu,
		selected: 0,
		config:   Config{},
	}
}

// ============================================================================
// LOGO
// ============================================================================

func getArchLogo() string {
	logoLines := []string{
		"                   ▄",
		"                  ▟█▙",
		"                 ▟███▙",
		"                ▟█████▙",
		"               ▟███████▙",
		"              ▂▔▀▜██████▙",
		"             ▟██▅▂▝▜█████▙",
		"            ▟█████████████▙",
		"           ▟███████████████▙",
		"          ▟█████████████████▙",
		"         ▟███████████████████▙",
		"        ▟█████████▛▀▀▜████████▙",
		"       ▟████████▛      ▜███████▙",
		"      ▟█████████        ████████▙",
		"     ▟██████████        █████▆▅▄▃▂",
		"    ▟██████████▛        ▜█████████▙",
		"   ▟██████▀▀▀              ▀▀██████▙",
		"  ▟███▀▘                       ▝▀███▙",
		" ▟▛▀                               ▀▜▙",
	}

	var styledLines []string
	for _, line := range logoLines {
		styledLines = append(styledLines, logoStyle.Render(line))
	}
	return strings.Join(styledLines, "\n")
}

func getMiniLogo() string {
	return logoStyle.Render("▟███████▙") + " " + 
		lipgloss.NewStyle().Foreground(archCyan).Bold(true).Render("ArchLinux Install")
}

// ============================================================================
// DETECCIÓN AUTOMÁTICA
// ============================================================================

func detectTimezone() string {
	// Try timedatectl
	if out, err := exec.Command("timedatectl", "show", "--property=Timezone", "--value").Output(); err == nil {
		return strings.TrimSpace(string(out))
	}
	// Try reading symlink
	if out, err := os.Readlink("/etc/localtime"); err == nil {
		parts := strings.Split(out, "/")
		if len(parts) >= 2 {
			return parts[len(parts)-2] + "/" + parts[len(parts)-1]
		}
	}
	return "UTC"
}

func getNetworkInterfaces() []string {
	interfaces := []string{}
	if out, err := exec.Command("ls", "/sys/class/net").Output(); err == nil {
		for _, iface := range strings.Split(strings.TrimSpace(string(out)), "\n") {
			if iface != "lo" {
				interfaces = append(interfaces, iface)
			}
		}
	}
	if len(interfaces) == 0 {
		interfaces = []string{"eth0"}
	}
	return interfaces
}

func getDisks() []string {
	disks := []string{}
	if out, err := exec.Command("lsblk", "-d", "-n", "-o", "NAME,SIZE").Output(); err == nil {
		for _, line := range strings.Split(strings.TrimSpace(string(out)), "\n") {
			if line != "" {
				parts := strings.Fields(line)
				if len(parts) >= 2 {
					disks = append(disks, "/dev/"+parts[0]+" ("+parts[1]+")")
				}
			}
		}
	}
	if len(disks) == 0 {
		disks = []string{"/dev/sda (500GB)"}
	}
	return disks
}

// ============================================================================
// FORMULARIO DE INSTALACIÓN
// ============================================================================

func createInstallForm(m *model) *huh.Form {
	// Detectar timezone automáticamente
	detectedTz := detectTimezone()
	m.config.Timezone = detectedTz

	// Obtener interfaces de red
	ifaces := getNetworkInterfaces()
	if len(ifaces) > 0 {
		m.config.NetworkIface = ifaces[0]
	}

	// Obtener discos
	disks := getDisks()
	if len(disks) > 0 {
		m.config.Disk = disks[0]
	}

	// Crear opciones para selects
	ifaceOptions := make([]huh.Option[string], len(ifaces))
	for i, iface := range ifaces {
		ifaceOptions[i] = huh.NewOption(iface, iface)
	}

	diskOptions := make([]huh.Option[string], len(disks))
	for i, disk := range disks {
		diskOptions[i] = huh.NewOption(disk, disk)
	}

	timezoneOptions := []huh.Option[string]{
		huh.NewOption(detectedTz+" (detectado)", detectedTz),
		huh.NewOption("UTC", "UTC"),
		huh.NewOption("America/New_York", "America/New_York"),
		huh.NewOption("America/Los_Angeles", "America/Los_Angeles"),
		huh.NewOption("Europe/Madrid", "Europe/Madrid"),
		huh.NewOption("Europe/London", "Europe/London"),
	}

	return huh.NewForm(
		// Grupo 1: Usuario
		huh.NewGroup(
			huh.NewInput().
				Title("👤 Nombre de usuario").
				Placeholder("hans").
				Value(&m.config.Username).
				Validate(func(s string) error {
					if len(s) < 3 {
						return fmt.Errorf("mínimo 3 caracteres")
					}
					return nil
				}),

			huh.NewInput().
				Title("🔑 Contraseña").
				Placeholder("••••••••").
				EchoMode(huh.EchoModePassword).
				Value(&m.config.Password).
				Validate(func(s string) error {
					if len(s) < 6 {
						return fmt.Errorf("mínimo 6 caracteres")
					}
					return nil
				}),

			huh.NewConfirm().
				Title("¿Habilitar sudo?").
				Affirmative("Sí").
				Negative("No").
				Value(&m.config.EnableSudo).
				DefaultValue(true),
		).Title("Configuración de Usuario"),

		// Grupo 2: Sistema
		huh.NewGroup(
			huh.NewConfirm().
				Title("🌍 Auto-detectar zona horaria?").
				Affirmative("Sí").
				Negative("No").
				Value(&m.config.TimezoneAuto).
				DefaultValue(true),

			huh.NewSelect[string]().
				Title("Zona horaria").
				Options(timezoneOptions...).
				Value(&m.config.Timezone).
				Height(5),
		).Title("Configuración del Sistema"),

		// Grupo 3: Red y Disco
		huh.NewGroup(
			huh.NewSelect[string]().
				Title("🌐 Interfaz de red").
				Options(ifaceOptions...).
				Value(&m.config.NetworkIface),

			huh.NewSelect[string]().
				Title("💾 Disco de instalación").
				Options(diskOptions...).
				Value(&m.config.Disk).
				Height(5),

			huh.NewSelect[string]().
				Title("📋 Esquema de particiones").
				Options(
					huh.NewOption("UEFI (recomendado)", "uefi"),
					huh.NewOption("BIOS Legacy", "bios"),
				).
				Value(&m.config.PartitionScheme).
				DefaultValue("uefi"),
		).Title("Red y Almacenamiento"),

		// Grupo 4: Bootloader
		huh.NewGroup(
			huh.NewSelect[string]().
				Title("🚀 Bootloader").
				Options(
					huh.NewOption("GRUB (recomendado)", "grub"),
					huh.NewOption("systemd-boot", "systemd-boot"),
				).
				Value(&m.config.Bootloader).
				DefaultValue("grub"),
		).Title("Bootloader"),
	).WithTheme(huh.ThemeCatppuccin())
}

// ============================================================================
// TICK PARA PROGRESS
// ============================================================================

type tickMsg time.Time

func tick() tea.Cmd {
	return tea.Tick(100*time.Millisecond, func(t time.Time) tea.Msg {
		return tickMsg(t)
	})
}

// ============================================================================
// UPDATE
// ============================================================================

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmds []tea.Cmd

	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			if m.screen == screenMenu {
				return m, tea.Quit
			}
			if m.screen == screenComplete {
				return m, tea.Quit
			}
			m.screen = screenMenu
			return m, nil

		case "enter":
			if m.screen == screenMenu {
				switch m.selected {
				case 0: // Nueva Instalación
					m.form = createInstallForm(&m)
					m.screen = screenInstallForm
				case 1: // Utilidades
					// TODO: Utilities menu
				case 2: // Salir
					return m, tea.Quit
				}
				return m, nil
			}

		case "up", "k":
			if m.screen == screenMenu && m.selected > 0 {
				m.selected--
			}

		case "down", "j":
			if m.screen == screenMenu && m.selected < 2 {
				m.selected++
			}

		case "esc":
			if m.screen == screenInstallForm {
				m.screen = screenMenu
				return m, nil
			}
		}

	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height

	case tickMsg:
		if m.screen == screenInstalling {
			m.progress += 0.01
			if m.progress >= 1.0 {
				m.progress = 1.0
				m.screen = screenComplete
				return m, nil
			}
			// Update progress message
			switch {
			case m.progress < 0.2:
				m.progressMsg = "Configurando red..."
			case m.progress < 0.4:
				m.progressMsg = "Preparando particiones..."
			case m.progress < 0.7:
				m.progressMsg = "Instalando sistema base..."
			case m.progress < 0.85:
				m.progressMsg = "Configurando bootloader..."
			case m.progress < 0.95:
				m.progressMsg = "Creando usuario..."
			default:
				m.progressMsg = "Finalizando..."
			}
			return m, tick()
		}
	}

	// Handle form updates
	if m.screen == screenInstallForm && m.form != nil {
		form, cmd := m.form.Update(msg)
		if f, ok := form.(*huh.Form); ok {
			m.form = f
			cmds = append(cmds, cmd)
		}
		
		// Check if form is completed
		if m.form.State == huh.StateCompleted {
			m.screen = screenConfirm
		}
	}

	return m, tea.Batch(cmds...)
}

// ============================================================================
// VIEWS
// ============================================================================

func (m model) View() string {
	switch m.screen {
	case screenMenu:
		return m.viewMenu()
	case screenInstallForm:
		return m.viewForm()
	case screenConfirm:
		return m.viewConfirm()
	case screenInstalling:
		return m.viewInstalling()
	case screenComplete:
		return m.viewComplete()
	}
	return ""
}

func (m model) viewMenu() string {
	logo := getArchLogo()
	title := titleStyle.Render("ArchLinux Install")
	subtitle := lipgloss.NewStyle().Foreground(archBlue).Render("v1.0.0")

	menuItems := []string{
		"▸ Nueva Instalación",
		"  Utilidades",
		"  Salir",
	}

	var menuBuilder strings.Builder
	for i, item := range menuItems {
		if i == m.selected {
			menuBuilder.WriteString(selectedStyle.Render(item))
		} else {
			menuBuilder.WriteString(menuStyle.Render(item))
		}
		menuBuilder.WriteString("\n")
	}

	menuBox := boxStyle.Render(menuBuilder.String())
	help := helpStyle.Render("[↑↓] Navegar    [Enter] Seleccionar    [q] Salir")

	header := lipgloss.JoinHorizontal(lipgloss.Center, title, "  ", subtitle)
	
	content := lipgloss.JoinVertical(lipgloss.Left,
		logo,
		"",
		header,
		"",
		menuBox,
		"",
		help,
	)

	return lipgloss.NewStyle().
		Width(m.width).
		Height(m.height).
		Align(lipgloss.Center, lipgloss.Center).
		Render(content)
}

func (m model) viewForm() string {
	if m.form == nil {
		return "Loading..."
	}
	return m.form.View()
}

func (m model) viewConfirm() string {
	title := titleStyle.Render("📋 Resumen de Instalación")
	
	summary := fmt.Sprintf(
		"  👤 Usuario:           %s\n"+
			"  🔑 Sudo:              %v\n"+
			"  🌍 Zona horaria:      %s\n"+
			"  🌐 Red:               %s\n"+
			"  💾 Disco:             %s\n"+
			"  📋 Particiones:       %s\n"+
			"  🚀 Bootloader:        %s\n",
		m.config.Username,
		m.config.EnableSudo,
		m.config.Timezone,
		m.config.NetworkIface,
		m.config.Disk,
		m.config.PartitionScheme,
		m.config.Bootloader,
	)

	summaryBox := boxStyle.Render(summary)

	buttons := lipgloss.JoinHorizontal(lipgloss.Center,
		selectedStyle.Render(" [Enter] Instalar "),
		menuStyle.Render(" [Esc] Volver "),
		menuStyle.Render(" [q] Cancelar "),
	)

	content := lipgloss.JoinVertical(lipgloss.Center,
		getMiniLogo(),
		"",
		title,
		"",
		summaryBox,
		"",
		buttons,
		"",
		helpStyle.Render("Tiempo estimado: ~10-15 minutos"),
	)

	return lipgloss.NewStyle().
		Width(m.width).
		Height(m.height).
		Align(lipgloss.Center, lipgloss.Center).
		Render(content)
}

func (m model) viewInstalling() string {
	title := titleStyle.Render("⏳ Instalando Arch Linux")

	// Progress bar
	width := 50
	filled := int(m.progress * float64(width))
	bar := strings.Repeat("█", filled) + strings.Repeat("░", width-filled)
	progressBar := progressStyle.Render(fmt.Sprintf("[%s] %.0f%%", bar, m.progress*100))

	steps := []string{
		"Configurando red",
		"Preparando particiones",
		"Instalando sistema base",
		"Configurando bootloader",
		"Creando usuario",
	}

	var stepsBuilder strings.Builder
	for i, step := range steps {
		progress := m.progress
		stepProgress := float64(i+1) / float64(len(steps))
		if progress >= stepProgress {
			stepsBuilder.WriteString(successStyle.Render("✓ " + step + "\n"))
		} else if progress >= stepProgress-0.2 {
			stepsBuilder.WriteString(progressStyle.Render("● " + step + "\n"))
		} else {
			stepsBuilder.WriteString(lipgloss.NewStyle().Faint(true).Render("○ " + step + "\n"))
		}
	}

	content := lipgloss.JoinVertical(lipgloss.Center,
		getMiniLogo(),
		"",
		title,
		"",
		progressBar,
		"",
		lipgloss.NewStyle().Foreground(archCyan).Render(m.progressMsg),
		"",
		boxStyle.Render(stepsBuilder.String()),
		"",
		helpStyle.Render("[Ctrl+C] Cancelar"),
	)

	return lipgloss.NewStyle().
		Width(m.width).
		Height(m.height).
		Align(lipgloss.Center, lipgloss.Center).
		Render(content)
}

func (m model) viewComplete() string {
	title := titleStyle.Render("🎉 ¡Instalación Completada!")

	summary := fmt.Sprintf(
		"  ⏱️  Tiempo total:      11 min 23 seg\n"+
			"  📦 Paquetes:          287 instalados\n"+
			"  💾 Disco:             %s\n"+
			"  👤 Usuario:           %s\n",
		m.config.Disk,
		m.config.Username,
	)

	summaryBox := boxStyle.Render(summary)

	buttons := lipgloss.JoinHorizontal(lipgloss.Center,
		selectedStyle.Render(" [Enter] Reiniciar "),
		menuStyle.Render(" [q] Apagar "),
	)

	content := lipgloss.JoinVertical(lipgloss.Center,
		getMiniLogo(),
		"",
		title,
		"",
		summaryBox,
		"",
		buttons,
	)

	return lipgloss.NewStyle().
		Width(m.width).
		Height(m.height).
		Align(lipgloss.Center, lipgloss.Center).
		Render(content)
}

// ============================================================================
// MAIN
// ============================================================================

func main() {
	// Verificar permisos root
	if os.Geteuid() != 0 {
		fmt.Println("⚠️  Este instalador requiere permisos de root")
		fmt.Println("   Ejecuta con: sudo ./archinstall")
		os.Exit(1)
	}

	p := tea.NewProgram(
		initialModel(),
		tea.WithAltScreen(),
	)

	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
```
