#!/bin/bash

# ═════════════════════════════════════════════════════════
# 🔑 GitHub CLI - Configuración Automática
# ═════════════════════════════════════════════════════════

set -e

# Verificar si gh está instalado
if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI no está instalado"
    exit 0
fi

# Verificar si ya está autenticado
if gh auth status &> /dev/null; then
    gum style \
        --foreground 46 \
        --border double \
        --align center \
        --width 60 \
        "✅ GitHub CLI ya autenticado"
    
    echo ""
    gh auth status
    exit 0
fi

# Si hay token, usarlo automáticamente
if [ -n "$GH_TOKEN" ]; then
    gum style \
        --foreground 39 \
        --border double \
        --align center \
        --width 60 \
        "🔑 Configurando GitHub CLI con token..."
    
    echo ""
    
    if echo "$GH_TOKEN" | gh auth login --with-token 2>/dev/null; then
        gum style --foreground 46 "✅ Autenticación exitosa"
        echo ""
        gh auth status
        exit 0
    else
        gum style --foreground 196 "❌ Token inválido"
        echo ""
    fi
fi

# Si no hay token o falló, pedirlo interactivamente
gum style \
    --foreground 212 \
    --border double \
    --align center \
    --width 70 \
    "🔑 GitHub CLI - Autenticación Requerida"

echo ""
gum style --foreground 245 "Se necesita un GitHub Personal Access Token"
echo ""

choice=$(gum choose \
    "Ingresar Token" \
    "Login con Browser" \
    "Cancelar" \
    --cursor "👉")

echo ""

case $choice in
    "Ingresar Token")
        gum style --foreground 226 "📝 Pega tu GitHub Personal Access Token:"
        echo ""
        
        # Pedir token con gum
        token=$(gum input \
            --password \
            --placeholder "github_pat_..." \
            --width 70)
        
        echo ""
        
        if [ -z "$token" ]; then
            gum style --foreground 196 "❌ No se ingresó token"
            exit 1
        fi
        
        # Intentar autenticar
        if echo "$token" | gh auth login --with-token; then
            echo ""
            gum style --foreground 46 "✅ Autenticación exitosa"
            echo ""
            gh auth status
            
            # Guardar token para futuras sesiones (opcional)
            echo ""
            if gum confirm "¿Guardar token para futuras sesiones?"; then
                echo "export GH_TOKEN=\"$token\"" >> /root/.zshrc
                gum style --foreground 46 "✅ Token guardado en ~/.zshrc"
            fi
        else
            echo ""
            gum style --foreground 196 "❌ Token inválido"
            exit 1
        fi
        ;;
    
    "Login con Browser")
        gum style --foreground 39 "🌐 Abriendo navegador..."
        gh auth login
        ;;
    
    "Cancelar")
        gum style --foreground 245 "⏭️  Autenticación omitida"
        echo ""
        gum style --foreground 226 "💡 Puedes autenticarte más tarde con: gh auth login"
        exit 0
        ;;
esac