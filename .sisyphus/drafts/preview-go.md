# preview.go code

```go
package main

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/lipgloss"
)

// Colores Arch Linux
var (
	archBlue   = lipgloss.Color("#1793D1")
	archCyan   = lipgloss.Color("#00FFFF")
	archWhite  = lipgloss.Color("#FFFFFF")
	selectedBg = lipgloss.Color("#1793D1")
)

var (
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

func main() {
	// Logo
	logo := getArchLogo()

	// Título
	title := titleStyle.Render("ArchLinux Install")
	subtitle := lipgloss.NewStyle().Foreground(archBlue).Render("v1.0.0")

	// Menú
	menuItems := []string{
		"▸ Nueva Instalación",
		"  Utilidades",
		"  Salir",
	}

	var menuBuilder strings.Builder
	for i, item := range menuItems {
		if i == 0 {
			menuBuilder.WriteString(selectedStyle.Render(item))
		} else {
			menuBuilder.WriteString(menuStyle.Render(item))
		}
		menuBuilder.WriteString("\n")
	}

	menuBox := boxStyle.Render(menuBuilder.String())
	help := helpStyle.Render("[↑↓] Navegar    [Enter] Seleccionar    [q] Salir")

	// Layout
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

	// Centrar
	fullContent := lipgloss.NewStyle().
		Width(80).
		Height(40).
		Align(lipgloss.Center, lipgloss.Center).
		Render(content)

	fmt.Println(fullContent)
}
```
