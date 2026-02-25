
STRINGS: dict[str, dict[str, str]] = {
    "es": {
        "app.title": "ArchLinux Install TUI",
        "menu.new_install": "Nueva Instalación",
        "menu.utilities": "Utilidades",
        "menu.exit": "Salir",
        "menu.select": "Selecciona una opción",
        "new_install.title": "Nueva Instalación",
        "new_install.datetime": "Fecha y Hora",
        "new_install.pacman": "Actualizar Pacman",
        "new_install.partitions": "Particiones",
        "new_install.arch": "Instalar Arch",
        "new_install.archinstall": "Archinstall",
        "new_install.post_install": "Post Instalación",
        "new_install.wizard": "Asistente Completo",
        "utilities.title": "Utilidades",
        "utilities.hyprland": "Configurar Hyprland",
        "utilities.plymouth": "Configurar Plymouth",
        "utilities.remmina": "Configurar Remmina",
        "utilities.dotfiles": "Mover a Dotfiles",
        "exit.confirm": "¿Seguro que deseas salir?",
        "exit.yes": "Sí",
        "exit.no": "No",
        "error.generic": "Ha ocurrido un error",
        "success.saved": "Guardado correctamente",
        "theme.title": "Seleccionar Tema",
        "language.title": "Seleccionar Idioma",
        "language.es": "Español",
        "language.en": "Inglés",
    },
    "en": {
        "app.title": "ArchLinux Install TUI",
        "menu.new_install": "New Installation",
        "menu.utilities": "Utilities",
        "menu.exit": "Exit",
        "menu.select": "Select an option",
        "new_install.title": "New Installation",
        "new_install.datetime": "Date and Time",
        "new_install.pacman": "Update Pacman",
        "new_install.partitions": "Partitions",
        "new_install.arch": "Install Arch",
        "new_install.archinstall": "Archinstall",
        "new_install.post_install": "Post Installation",
        "new_install.wizard": "Full Wizard",
        "utilities.title": "Utilities",
        "utilities.hyprland": "Configure Hyprland",
        "utilities.plymouth": "Configure Plymouth",
        "utilities.remmina": "Configure Remmina",
        "utilities.dotfiles": "Move to Dotfiles",
        "exit.confirm": "Are you sure you want to exit?",
        "exit.yes": "Yes",
        "exit.no": "No",
        "error.generic": "An error has occurred",
        "success.saved": "Saved successfully",
        "theme.title": "Select Theme",
        "language.title": "Select Language",
        "language.es": "Spanish",
        "language.en": "English",
    },
}


def t(key: str, lang: str | None = None) -> str:
    if lang is None:
        from archinstall_tui.core.config import get_config

        lang = get_config().lang

    if lang not in STRINGS:
        lang = "en"

    return STRINGS.get(lang, {}).get(key, key)


def get_available_languages() -> list[str]:
    return list(STRINGS.keys())
