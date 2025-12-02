#!/bin/bash

# Кольори
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Medical Analysis Backend - Start Server  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"

# Перевірка чи існує venv
if [ ! -d ".venv" ]; then
    echo -e "${YELLOW}Virtual environment not found. Creating...${NC}"
    python3 -m venv .venv
    echo -e "${GREEN}✓ Virtual environment created${NC}\n"
fi

# Активація venv
echo -e "${YELLOW}Activating virtual environment...${NC}"
source .venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated${NC}\n"

# Перевірка чи встановлені залежності
if ! python -c "import flask" 2>/dev/null; then
    echo -e "${YELLOW}Installing dependencies...${NC}"
    python -m pip install -r requirements.txt
    echo -e "${GREEN}✓ Dependencies installed${NC}\n"
fi

# Перевірка чи існує .env
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}.env file not found. Copying from .env.example...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created${NC}"
    echo -e "${YELLOW}⚠️  Please edit .env file and set your API_KEY${NC}\n"
fi

# Запуск сервера
echo -e "${BLUE}Starting Flask server...${NC}\n"
python app.py

