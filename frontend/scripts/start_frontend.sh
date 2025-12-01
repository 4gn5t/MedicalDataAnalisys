#!/bin/bash

# Кольори
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Medical Analysis Frontend - Start        ║${NC}"
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
if ! python -c "import streamlit" 2>/dev/null; then
    echo -e "${YELLOW}Installing dependencies...${NC}"
    python -m pip install -r requirements.txt
    echo -e "${GREEN}✓ Dependencies installed${NC}\n"
fi

# Перевірка чи існує .env
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}.env file not found. Copying from .env.example...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✓ .env file created${NC}"
    echo -e "${YELLOW}⚠️  Please edit .env file and set your BACKEND_API_URL and API_KEY${NC}\n"
fi

# Перевірка підключення до backend
echo -e "${YELLOW}Checking backend connection...${NC}"
BACKEND_URL=$(grep BACKEND_API_URL .env | cut -d '=' -f2)

if curl -s "$BACKEND_URL/health" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Backend is reachable at $BACKEND_URL${NC}\n"
else
    echo -e "${RED}⚠️  Warning: Backend is not reachable at $BACKEND_URL${NC}"
    echo -e "${YELLOW}Please make sure backend is running:${NC}"
    echo -e "  cd ../backend"
    echo -e "  ./start_server.sh"
    echo -e ""
fi

# Запуск Streamlit
echo -e "${BLUE}Starting Streamlit frontend...${NC}\n"
streamlit run app.py

