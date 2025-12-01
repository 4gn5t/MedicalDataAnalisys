#!/bin/bash

# Кольори
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Medical Analysis - Pytest Tests      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"

# Активація venv
if [ -d ".venv" ]; then
    echo -e "${YELLOW}Activating virtual environment...${NC}"
    source .venv/bin/activate
    echo -e "${GREEN}✓ Virtual environment activated${NC}\n"
else
    echo -e "${RED}✗ Virtual environment not found!${NC}"
    echo -e "${YELLOW}Please run: python3 -m venv .venv${NC}"
    exit 1
fi

# Перевірка чи встановлений pytest
if ! python -c "import pytest" 2>/dev/null; then
    echo -e "${YELLOW}Installing pytest...${NC}"
    python -m pip install pytest pytest-flask
    echo -e "${GREEN}✓ Pytest installed${NC}\n"
fi

# Встановлення API_KEY для тестів
export API_KEY="test-api-key-12345"

# Запуск тестів
echo -e "${BLUE}Running pytest...${NC}\n"
python -m pytest tests/ -v --tb=short

# Перевірка результату
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          🎉 All tests passed! 🎉           ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
else
    echo -e "\n${RED}╔════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║           ❌ Some tests failed!            ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
    exit 1
fi

