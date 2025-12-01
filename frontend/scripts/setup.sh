#!/bin/bash

# Кольори
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Frontend Setup & Installation           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"

# Перевірка версії Python
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo -e "${YELLOW}Detected Python version: $PYTHON_VERSION${NC}"

MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

if [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 10 ]; then
    echo -e "${GREEN}✓ Python version is compatible${NC}\n"
else
    echo -e "${RED}✗ Python 3.10+ is required${NC}"
    echo -e "${YELLOW}Please install Python 3.10, 3.11, or 3.12 (recommended)${NC}"
    exit 1
fi

# Попередження для Python 3.13
if [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 13 ]; then
    echo -e "${YELLOW}⚠️  Warning: Python 3.13 detected${NC}"
    echo -e "${YELLOW}Some packages may have compatibility issues${NC}"
    echo -e "${YELLOW}Recommended: Python 3.10-3.12 for better stability${NC}\n"
fi

# Створення venv
if [ ! -d ".venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv .venv
    echo -e "${GREEN}✓ Virtual environment created${NC}\n"
else
    echo -e "${GREEN}✓ Virtual environment already exists${NC}\n"
fi

# Активація venv
echo -e "${YELLOW}Activating virtual environment...${NC}"
source .venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated${NC}\n"

# Оновлення pip
echo -e "${YELLOW}Upgrading pip...${NC}"
python -m pip install --upgrade pip -q
echo -e "${GREEN}✓ pip upgraded${NC}\n"

# Встановлення залежностей
echo -e "${YELLOW}Installing dependencies...${NC}"
echo -e "${BLUE}This may take a few minutes...${NC}\n"

python -m pip install -r requirements.txt

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✓ All dependencies installed successfully${NC}\n"
else
    echo -e "\n${RED}✗ Some dependencies failed to install${NC}"
    echo -e "${YELLOW}Trying alternative installation method...${NC}\n"

    # Спроба встановлення по одному пакету
    echo -e "${YELLOW}Installing packages individually...${NC}"
    python -m pip install streamlit
    python -m pip install requests
    python -m pip install "pandas>=2.2.0"
    python -m pip install plotly
    python -m pip install python-dotenv
    python -m pip install "numpy>=2.0.0"

    echo -e "\n${GREEN}✓ Installation completed${NC}\n"
fi

# Перевірка встановлених пакетів
echo -e "${YELLOW}Verifying installation...${NC}"
python -c "import streamlit; import pandas; import plotly; print('✓ All packages imported successfully')"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Verification passed${NC}\n"
else
    echo -e "${RED}✗ Verification failed${NC}\n"
    exit 1
fi

# Перевірка .env
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Creating .env file from template...${NC}"
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "${GREEN}✓ .env file created${NC}"
        echo -e "${YELLOW}⚠️  Please edit .env file if needed${NC}\n"
    else
        echo -e "${RED}✗ .env.example not found${NC}\n"
    fi
else
    echo -e "${GREEN}✓ .env file exists${NC}\n"
fi

# Фінальні інструкції
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Setup Complete!                   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"

echo -e "${GREEN}Next steps:${NC}"
echo -e "1. Make sure backend is running:"
echo -e "   ${BLUE}cd ../backend && ./start_server.sh${NC}"
echo -e ""
echo -e "2. Start frontend:"
echo -e "   ${BLUE}./scripts/start_frontend.sh${NC}"
echo -e "   ${YELLOW}or${NC}"
echo -e "   ${BLUE}streamlit run app.py${NC}"
echo -e ""
echo -e "3. Open in browser:"
echo -e "   ${BLUE}http://localhost:8501${NC}"
echo -e ""

