#!/bin/bash

# ============================================
# 🏥 Medical Data Analysis - Stop Script
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════╗"
echo "║  🛑 Зупинка Medical Data Analysis          ║"
echo "╚════════════════════════════════════════════╝"
echo -e "${NC}"

cd "$PROJECT_DIR"

# Зупинка через docker-compose
if [ -f "docker-compose.yml" ]; then
    echo -e "${YELLOW}➤ Зупинка Docker контейнерів...${NC}"
    docker-compose down
    echo -e "${GREEN}✔ Docker контейнери зупинено${NC}"
fi

# Додатково перевіряємо порти
BACKEND_PORT=5001
FRONTEND_PORT=8501

kill_port() {
    local port=$1
    local pids=$(lsof -ti :$port 2>/dev/null)
    if [ -n "$pids" ]; then
        echo -e "${YELLOW}➤ Звільнення порту $port...${NC}"
        echo "$pids" | xargs kill -9 2>/dev/null || true
        echo -e "${GREEN}✔ Порт $port звільнено${NC}"
    fi
}

kill_port $BACKEND_PORT
kill_port $FRONTEND_PORT

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       ✔ Всі сервіси зупинено!              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
