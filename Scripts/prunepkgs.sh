#!/bin/bash
# prunepkgs.sh — Safe Arch package pruning helper with logging & safeguard

# Directories for logs
logdir="$HOME/.local/share/pkg-prune-logs"
mkdir -p "$logdir"

# Step 1: list orphaned packages
# pacman exits with status 1 (and prints an error) when no orphans exist, so
# swallow the non-critical error output while still capturing the list.
orphans=$(pacman -Qdtq 2>/dev/null || true)

echo "=== Orphaned packages ==="
if [ -z "$orphans" ]; then
    echo "No orphaned packages found 🎉"
else
    echo "$orphans"
fi
echo

# Step 2: quick search for 'watched' packages (apps tied to configs)
watched=("grass" "waybar" "swww" "hyprland" "wofi" "gnome-weather")

echo "=== Watched packages installed ==="
for pkg in "${watched[@]}"; do
    if pacman -Qi "$pkg" >/dev/null 2>&1; then
        echo "⚠️  $pkg is installed (linked to your configs)"
    fi
done
echo

# Step 3: interactive orphan removal
if [ -n "$orphans" ]; then
    # Filter out watched packages from orphans
    safe_orphans=()
    for o in $orphans; do
        if [[ " ${watched[*]} " =~ " ${o} " ]]; then
            echo "⏭️  Skipping $o (watched package)"
        else
            safe_orphans+=("$o")
        fi
    done

    if [ ${#safe_orphans[@]} -eq 0 ]; then
        echo "No safe orphaned packages to remove."
    else
        echo "Do you want to remove these orphaned packages? (y/N)"
        echo "${safe_orphans[@]}"
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') — Removing: ${safe_orphans[*]}" >> "$logdir/prune.log"
            sudo pacman -Rns "${safe_orphans[@]}"
            echo "$(date '+%Y-%m-%d %H:%M:%S') — Done removing above packages ✅" >> "$logdir/prune.log"
        else
            echo "Skipping removal."
        fi
    fi
fi

echo "Done. System pruned safely 🌱"
