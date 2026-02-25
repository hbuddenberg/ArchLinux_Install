# Plan: Fix CSS para Textual 8.0.0

## TL;DR

> **Quick Summary**: Arreglar styles.tcss eliminando @keyframes que no es compatible con Textual 8.0.0

---

## Problema

```
Error in stylesheet:
 @keyframes fadeIn {
 • Expected selector or end of file
```

Textual 8.0.0 no soporta `@keyframes` en CSS.

---

## Solución

Eliminar las líneas 43-50 del archivo `/workspace/archinstall_tui/src/archinstall_tui/tui/styles.tcss`:

**Eliminar:**
```css
.logo-loaded {
    animation: fadeIn 0.5s ease-out;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}
```

**Reemplazar con:**
```css
.logo-loaded {
    text-style: bold;
}
```

---

## TODO

 [x] 1. Editar styles.tcss eliminando @keyframes

---

## Archivo Final

```css
Screen {
    align: center middle;
}

#menu-container {
    width: auto;
    height: auto;
}

#menu-prompt {
    text-align: center;
    margin-bottom: 1;
    color: $text-muted;
}

#menu-buttons {
    width: auto;
    height: auto;
    align: center middle;
}

#menu-buttons Button {
    width: 30;
    margin: 1;
}

Button:focus {
    text-style: bold;
}

Header {
    dock: top;
}

Footer {
    dock: bottom;
}

ArchLogo {
    color: $primary;
}

.logo-loaded {
    text-style: bold;
}
```

---

## Verificación

```bash
cd /workspace/archinstall_tui
uv run archinstall-tui
```
