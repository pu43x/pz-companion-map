#!/bin/bash
set -e

DZI="/output/html/map_data/base/layer0.dzi"

if [ -f "$DZI" ]; then
    echo "[pz-companion-map] Tiles already exist — skipping generation."
    echo "[pz-companion-map] Delete $DZI to force a rebuild."
    exit 0
fi

echo "[pz-companion-map] Starting tile generation (this takes 20-60 minutes)..."

python main.py -c /app/conf/docker.yaml deploy
python main.py -c /app/conf/docker.yaml unpack
python main.py -c /app/conf/docker.yaml render base

echo "[pz-companion-map] Pruning zoom levels above 16 to save disk space..."
for level_dir in /output/html/map_data/base/layer0_files/*/; do
    level=$(basename "$level_dir")
    if [ "$level" -gt 16 ] 2>/dev/null; then
        echo "  removing level $level"
        rm -rf "$level_dir"
    fi
done

echo "[pz-companion-map] Done! Tiles are at /output/html/map_data/"
