# preview_form.go code

```go
package main

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/lipgloss"
)

var (
	archBlue   = lipgloss.Color("#1793D1")
	archCyan   = lipgloss.Color("#00FFFF")
	archWhite  = lipgloss.Color("#FFFFFF")
	selectedBg = lipgloss.Color("#1793D1")

	titleStyle = lipgloss.NewStyle().
			Foreground(archCyan).
			Bold(true).
			Padding(1, 0).
			Align(lipgloss.Center)

	logoStyle = lipgloss.NewStyle().
			Foreground(archBlue)

	boxStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(archBlue).
			Padding(1, 2).
			Margin(1, 0)

	selectedStyle = lipgloss.NewStyle().
			Foreground(archWhite).
			Background(selectedBg).
			Bold(true).
			Padding(0, 2)

	helpStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#666666")).
			Padding(1, 0)

	inputStyle = lipgloss.NewStyle().
			Foreground(archWhite).
			Background(lipgloss.Color("#1B2838")).
			Padding(0, 1).
			Width(40)

	focusedStyle = lipgloss.NewStyle().
			Foreground(archWhite).
			Background(archBlue).
			Bold(true).
			Padding(0, 1).
			Width(40)

	progressStyle = lipgloss.NewStyle().
			Foreground(archCyan).
			Bold(true)

	successStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#00FF00")).
			Bold(true)
)

func getMiniLogo() string {
	return logoStyle.Render("▟███████▙") + " " + 
		lipgloss.NewStyle().Foreground(archCyan).Bold(true).Render("ArchLinux Install")
}

func previewMenu() string {
	logo := getMiniLogo()
	title := titleStyle.Render("ArchLinux Install")
	subtitle := lipgloss.NewStyle().Foreground(archBlue).Render("v1.0.0")

	menuItems := []string{
		"▸ Nueva Instalación",
		"  Utilidades",
		"  Salir",
	}

	var menuBuilder strings.Builder
	for _, item := range menuItems {
		menuBuilder.WriteString(item + "\n")
	}

	menuBox := boxStyle.Render(menuBuilder.String())
	help := helpStyle.Render("[↑↓] Navegar    [Enter] Seleccionar    [q] Salir")

	header := lipgloss.JoinHorizontal(lipgloss.Center, title, "  ", subtitle)
	
	return lipgloss.JoinVertical(lipgloss.Left,
		"",
		logo,
		"",
		header,
		"",
		menuBox,
		"",
		help,
		"",
	)
}

func previewForm() string {
	title := titleStyle.Render("Configuración de Usuario")

	form := `  👤 Nombre de usuario
  ` + focusedStyle.Render("hans_                    ") + `
  
  🔑 Contraseña
  ` + inputStyle.Render("••••••••                 ") + `
  Fortaleza: ████████░░ Fuerte

  ¿Habilitar sudo? [✓] Sí`

	return lipgloss.JoinVertical(lipgloss.Left,
		"",
		getMiniLogo(),
		"",
		title,
		"",
		boxStyle.Render(form),
		"",
		helpStyle.Render("[Tab] Siguiente    [Shift+Tab] Anterior    [Enter] Continuar"),
		"",
	)
}

func previewConfirm() string {
	title := titleStyle.Render("📋 Resumen de Instalación")
	
	summary := `  👤 Usuario:           hans_
  🔑 Sudo:              true
  🌍 Zona horaria:      America/New_York
  🌐 Red:               enp0s3
  💾 Disco:             /dev/sda (500 GB)
  📋 Particiones:       uefi
  🚀 Bootloader:        grub`

	buttons := lipgloss.JoinHorizontal(lipgloss.Center,
		selectedStyle.Render(" [Enter] Instalar "),
		"  ",
		inputStyle.Render(" [Esc] Volver "),
	)

	return lipgloss.JoinVertical(lipgloss.Center,
		"",
		getMiniLogo(),
		"",
		title,
		"",
		boxStyle.Render(summary),
		"",
		buttons,
		"",
		helpStyle.Render("Tiempo estimado: ~10-15 minutos"),
		"",
	)
}

func previewInstalling() string {
	title := titleStyle.Render("⏳ Instalando Arch Linux")

	// Progress bar
	bar := "████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
	progressBar := progressStyle.Render(fmt.Sprintf("[%s] 45%%", bar))

	steps := successStyle.Render("✓ Configurando red") + "\n" +
		successStyle.Render("✓ Preparando particiones") + "\n" +
		progressStyle.Render("● Instalando sistema base") + "\n" +
		lipgloss.NewStyle().Faint(true).Render("○ Configurando bootloader") + "\n" +
		lipgloss.NewStyle().Faint(true).Render("○ Creando usuario")

	return lipgloss.JoinVertical(lipgloss.Center,
		"",
		getMiniLogo(),
		"",
		title,
		"",
		progressBar,
		"",
		lipgloss.NewStyle().Foreground(archCyan).Render("Descargando: linux-6.7.0-1-x86_64.pkg.tar.zst"),
		"",
		boxStyle.Render(steps),
		"",
		helpStyle.Render("[Ctrl+C] Cancelar"),
		"",
	)
}

func previewComplete() string {
	title := titleStyle.Render("🎉 ¡Instalación Completada!")

	summary := `  ⏱️  Tiempo total:      11 min 23 seg
  📦 Paquetes:          287 instalados
  💾 Disco:             /dev/sda (500 GB)
  👤 Usuario:           hans_`

	buttons := lipgloss.JoinHorizontal(lipgloss.Center,
		selectedStyle.Render(" [Enter] Reiniciar "),
		"  ",
		inputStyle.Render(" [q] Apagar "),
	)

	return lipgloss.JoinVertical(lipgloss.Center,
		"",
		getMiniLogo(),
		"",
		title,
		"",
		boxStyle.Render(summary),
		"",
		buttons,
		"",
	)
}

func main() {
	fmt.Println("\n" + strings.Repeat("=", 70))
	fmt.Println("                    PANTALLA 1: MENÚ PRINCIPAL")
	fmt.Println(strings.Repeat("=", 70))
	fmt.Println(previewMenu())

	fmt.Println("\n" + strings.Repeat("=", 70))
	fmt.Println("                    PANTALLA 2: FORMULARIO DE INSTALACIÓN")
	fmt.Println(strings.Repeat("=", 70))
	fmt.Println(previewForm())

	fmt.Println("\n" + strings.Repeat("=", 70))
	fmt.Println("                    PANTALLA 3: CONFIRMACIÓN")
	fmt.Println(strings.Repeat("=", 70))
	fmt.Println(previewConfirm())

	fmt.Println("\n" + strings.Repeat("=", 70))
	fmt.Println("                    PANTALLA 4: INSTALANDO")
	fmt.Println(strings.Repeat("=", 70))
	fmt.Println(previewInstalling())

	fmt.Println("\n" + strings.Repeat("=", 70))
	fmt.Println("                    PANTALLA 5: COMPLETADO")
	fmt.Println(strings.Repeat("=", 70))
	fmt.Println(previewComplete())
}
```
