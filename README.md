# ArchHypr Install

Este proyecto es una colección de scripts en shell que facilitan la instalación y configuración de Arch Linux, así como la gestión de complementos y utilidades. La estructura del proyecto está organizada en diferentes módulos, cada uno con su propio conjunto de scripts y traducciones.

## Estructura del Proyecto

```sh
ArchLinux_install
├── src/                                        # Directorio principal de scripts
|   ├── main.sh                                 # Script principal que ejecuta el menú y selecciona el módulo a ejecutar
|   ├── configurations/                         # Directorio de configuraciones
|   |   ├── user_configuration.json             # Archivo de configuración del usuario
|   |   └── user_credentials.json               # Archivo de credenciales del usuario
|   ├── modules/                                # Directorio de módulos
|   |   ├── main.sh                             # Script principal de los módulos
|   |   ├── date_time_zone/                     # Módulo para configurar fecha y hora
|   |   |   ├── main.sh                         # Script principal del módulo de fecha y hora
|   |   |   └── SUPPORTED                       # Archivo con las localizaciones soportadas
|   |   ├── install_arch/                       # Módulo para instalar Arch Linux
|   |   |   └── main.sh                         # Script principal del módulo de instalación de Arch Linux
|   |   ├── install_by_archinstall/             # Módulo para instalar usando Archinstall
|   |   |   └── main.sh                         # Script principal del módulo de instalación usando Archinstall
|   |   ├── pacman_update/                      # Módulo para actualizar Pacman
|   |   |   └── main.sh                         # Script principal del módulo de actualización de Pacman
|   |   ├── partitions/                         # Módulo para crear particiones
|   |   |   ├── main.sh                         # Script principal del módulo de particiones
|   |   |   └── main.sh.bak                     # Copia de seguridad del script principal del módulo de particiones
|   |   ├── post_install/                       # Módulo de post-instalación
|   |   |   ├── chroot_commands.sh              # Script con comandos para ejecutar en chroot
|   |   |   └── main.sh                         # Script principal del módulo de post-instalación
|   |   ├── swap/                               # Módulo para configurar swap
|   |   |   └── main.sh                         # Script principal del módulo de swap
|   |   └── utilities/                          # Directorio de utilidades
|   |       ├── hyprland/                       # Utilidades relacionadas con Hyprland
|   |       |   ├── hyprland.conf               # Archivo de configuración de Hyprland
|   |       |   └── main.sh                     # Script principal de utilidades de Hyprland
|   |       ├── plymouth/                       # Utilidades relacionadas con Plymouth
|   |       |   └── main.sh                     # Script principal de utilidades de Plymouth
|   |       └── remmina/                        # Utilidades relacionadas con Remmina
|   |           └── main.sh                     # Script principal de utilidades de Remmina
├── README.md                                   # Archivo README con información sobre el proyecto
├── LICENSE.md                                  # Archivo de licencia del proyecto
└── .gitignore                                  # Archivo para ignorar archivos y carpetas específicas en Git
```

## Funcionalidades

1. **Menu**: Proporciona un menú interactivo para navegar entre las diferentes opciones del script.
2. **Instalación**: Contiene scripts para la instalación de Arch Linux.
3. **Post-Instalación**: Incluye scripts para la configuración posterior a la instalación, organizados en módulos como `base` y `hyprland`.
4. **Utilidades**: Scripts para validar la conexión de red y Wi-Fi, así como otras utilidades como Hyprland, Plymouth y Remmina.

## Cómo Instalar

Para clonar el repositorio y ejecutar el script principal, siga estos pasos:

```sh
git clone https://github.com/HansBuddenbergBlamey/ArchLinux_install.git
cd ArchLinux_install/src
sudo main.sh
```

## Licencia

Consulte el archivo LICENSE.md para más detalles.

## Agradecimientos

Este proyecto se basa en el trabajo de la comunidad de Arch Linux y Hyprland. Sin el trabajo de la comunidad, esto no habría sido posible. 
Muchas de las ideas y piezas fueron obtenidas e incorporadas gracias a que la comunidad lo resolvió o dio ideas para formar este compendio de instalación.

Agradesco a las siguientes personas en especial, ya que sus información y desarrollos previos, dieron forma a mi propio proyecto.

- Stephan Raabe: https://www.ml4w.com
