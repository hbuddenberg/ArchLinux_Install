# Arch Linux Development Container

Este proyecto proporciona un contenedor de desarrollo basado en Arch Linux, diseñado para ejecutar scripts de shell y facilitar el uso de Git y Gum.

## Estructura del Proyecto

```
arch-linux-devcontainer
├── .devcontainer
│   ├── devcontainer.json
│   └── Dockerfile
└── README.md
```

## Instrucciones de Uso

1. **Requisitos Previos**: Asegúrate de tener instalado Docker y cualquier herramienta necesaria para ejecutar contenedores.

2. **Construir el Contenedor**:
   Navega a la carpeta del proyecto y ejecuta el siguiente comando para construir el contenedor:
   ```
   docker-compose up --build
   ```

3. **Abrir el Contenedor en el Editor**:
   Una vez construido, abre el contenedor en tu editor de código. Esto te permitirá acceder al entorno de desarrollo configurado.

4. **Ejecutar Scripts de Shell**:
   Puedes ejecutar scripts de shell directamente en el contenedor. Asegúrate de que tus scripts tengan permisos de ejecución.

## Ejemplos de Scripts de Shell

Aquí hay algunos ejemplos de scripts que puedes ejecutar dentro del contenedor:

### Ejemplo 1: Script de Hola Mundo

```bash
#!/bin/bash
echo "Hola, Mundo!"
```

### Ejemplo 2: Clonar un Repositorio de Git

```bash
#!/bin/bash
git clone https://github.com/tu_usuario/tu_repositorio.git
```

### Ejemplo 3: Usar Gum para Interacción

```bash
#!/bin/bash
gum choose "Opción 1" "Opción 2" "Opción 3"
```

## Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar este proyecto, por favor abre un issue o un pull request.