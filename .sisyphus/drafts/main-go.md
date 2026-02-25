# main.go code

```go
package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// ============================================================================
// ESTILOS - Paleta de colores Arch Linux
// ============================================================================

var (
	// Colores Arch Linux
	archBlue   = lipgloss.Color("#1793D1")
	archCyan   = lipgloss.Color("#00FFFF")
	archWhite  = lipgloss.Color("#FFFFFF")
	darkBg     = lipgloss.Color("#0D1B2A")
	lightBg    = lipgloss.Color("#1B2838")
	selectedBg = lipgloss.Color("#1793D1")

	// Estilos
	titleStyle = lipgloss.NewStyle().
			Foreground(archCyan).
			Bold(true).
			Padding(1, 0)

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
			Padding(1, 4).
			Margin(1, 0)
)

// ============================================================================
// MODELO
// ============================================================================

type menuItem struct {
	title       string
	description string
}

var menuItems = []menuItem{
	{"▸ Nueva Instalación", "Instalar Arch Linux paso a paso"},
	{"  Utilidades", "Herramientas adicionales"},
	{"  Salir", "Salir del instalador"},
}

type model struct {
	selected int
	width    int
	height   int
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "up", "k":
			if m.selected > 0 {
				m.selected--
			}
		case "down", "j":
			if m.selected < len(menuItems)-1 {
				m.selected++
			}
		case "enter", " ":
			if m.selected == len(menuItems)-1 {
				return m, tea.Quit
			}
			// TODO: Handle menu selection
		}
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	}
	return m, nil
}

func (m model) View() string {
	// Logo de Arch Linux
	logo := getArchLogo()

	// Título
	title := titleStyle.Render("ArchLinux Install")
	subtitle := lipgloss.NewStyle().
		Foreground(archBlue).
		Render("v1.0.0")

	// Menú
	var menuBuilder strings.Builder
	for i, item := range menuItems {
		if i == m.selected {
			menuBuilder.WriteString(selectedStyle.Render(item.title))
		} else {
			menuBuilder.WriteString(menuStyle.Render(item.title))
		}
		menuBuilder.WriteString("\n")
	}

	// Envolver menú en caja
	menuBox := boxStyle.Render(menuBuilder.String())

	// Ayuda
	help := helpStyle.Render("[↑↓] Navegar    [Enter] Seleccionar    [q] Salir")

	// Info contextual (esquina inferior)
	infoStyle := lipgloss.NewStyle().
		Foreground(lipgloss.Color("#888888")).
		Faint(true)
	info := infoStyle.Render("UEFI Mode • Root")

	// Construir layout
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

	// Centrar todo
	fullContent := lipgloss.NewStyle().
		Width(m.width).
		Height(m.height).
		Align(lipgloss.Center, lipgloss.Center).
		Render(content)

	// Agregar info en esquina
	return lipgloss.JoinVertical(lipgloss.Left,
		fullContent,
		lipgloss.NewStyle().Width(m.width).Align(lipgloss.Right).Render(info),
	)
}

// ============================================================================
// LOGO
// ============================================================================

func getArchLogo() string {
	// Logo ASCII de Arch Linux simplificado para mejor renderizado
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

// ============================================================================
// MAIN
// ============================================================================

func main() {
	// Verificar permisos root
	if os.Geteuid() != 0 {
		fmt.Println("Este instalador requiere permisos de root")
		fmt.Println("Ejecuta con: sudo ./archinstall")
		os.Exit(1)
	}

	p := tea.NewProgram(
		model{},
		tea.WithAltScreen(),
	)

	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
```
