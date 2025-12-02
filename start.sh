#!/bin/bash

# ============================================
# 🏥 Medical Data Analysis - Start Script
# ============================================
# Скрипт для запуску всього стеку на macOS
# Backend (Flask): port 5000
# Frontend (Streamlit): port 8501
# ============================================

set -e

# Кольори для виводу
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Конфігурація
BACKEND_PORT=5001
FRONTEND_PORT=8501
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$PROJECT_DIR/backend"
FRONTEND_DIR="$PROJECT_DIR/frontend"

# ============================================
# Функції
# ============================================

print_header() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════╗"
    echo "║  🏥 Medical Data Analysis Platform         ║"
    echo "║     Start Script for macOS                 ║"
    echo "╚════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}➤ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✔ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✖ $1${NC}"
}

# Перевірка чи порт зайнятий
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0  # порт зайнятий
    else
        return 1  # порт вільний
    fi
}

# Звільнення порту
kill_port() {
    local port=$1
    local pids=$(lsof -ti :$port 2>/dev/null)
    if [ -n "$pids" ]; then
        echo "$pids" | xargs kill -9 2>/dev/null || true
        sleep 1
    fi
}

# Перевірка залежностей
check_dependencies() {
    print_step "Перевірка залежностей..."
    
    local missing_deps=()
    
    # Docker
    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
    fi
    
    # Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        missing_deps+=("docker-compose")
    fi
    
    # Python (опційно, для локального запуску)
    if ! command -v python3 &> /dev/null; then
        print_warning "Python3 не знайдено (потрібен тільки для локального запуску)"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Відсутні залежності: ${missing_deps[*]}"
        echo ""
        echo "Встановіть їх за допомогою Homebrew:"
        echo "  brew install ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "Всі залежності встановлені"
}

# Перевірка Docker daemon
check_docker_running() {
    print_step "Перевірка Docker..."
    
    if ! docker info &> /dev/null; then
        print_error "Docker не запущено!"
        echo ""
        echo "Запустіть Docker Desktop і спробуйте знову."
        exit 1
    fi
    
    print_success "Docker працює"
}

# Перевірка та звільнення портів
check_ports() {
    print_step "Перевірка портів..."
    
    # Backend port
    if check_port $BACKEND_PORT; then
        print_warning "Порт $BACKEND_PORT зайнятий"
        read -p "Звільнити порт $BACKEND_PORT? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill_port $BACKEND_PORT
            print_success "Порт $BACKEND_PORT звільнено"
        else
            print_error "Порт $BACKEND_PORT необхідний для backend"
            exit 1
        fi
    else
        print_success "Порт $BACKEND_PORT вільний (Backend)"
    fi
    
    # Frontend port
    if check_port $FRONTEND_PORT; then
        print_warning "Порт $FRONTEND_PORT зайнятий"
        read -p "Звільнити порт $FRONTEND_PORT? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kill_port $FRONTEND_PORT
            print_success "Порт $FRONTEND_PORT звільнено"
        else
            print_error "Порт $FRONTEND_PORT необхідний для frontend"
            exit 1
        fi
    else
        print_success "Порт $FRONTEND_PORT вільний (Frontend)"
    fi
}

# Перевірка директорій
check_directories() {
    print_step "Перевірка структури проекту..."
    
    if [ ! -d "$BACKEND_DIR" ]; then
        print_error "Директорія backend не знайдена: $BACKEND_DIR"
        exit 1
    fi
    
    if [ ! -d "$FRONTEND_DIR" ]; then
        print_error "Директорія frontend не знайдена: $FRONTEND_DIR"
        exit 1
    fi
    
    print_success "Структура проекту OK"
}

# Створення .env файлів якщо їх немає
setup_env_files() {
    print_step "Налаштування .env файлів..."
    
    # Backend .env
    if [ ! -f "$BACKEND_DIR/.env" ]; then
        if [ -f "$BACKEND_DIR/.env.example" ]; then
            cp "$BACKEND_DIR/.env.example" "$BACKEND_DIR/.env"
            print_success "Створено backend/.env з .env.example"
        else
            cat > "$BACKEND_DIR/.env" << EOF
FLASK_ENV=development
FLASK_DEBUG=True
API_KEY=my-super-secret-api-key-2024
EOF
            print_success "Створено backend/.env"
        fi
    else
        print_success "backend/.env вже існує"
    fi
    
    # Frontend .env
    if [ ! -f "$FRONTEND_DIR/.env" ]; then
        if [ -f "$FRONTEND_DIR/.env.example" ]; then
            cp "$FRONTEND_DIR/.env.example" "$FRONTEND_DIR/.env"
            print_success "Створено frontend/.env з .env.example"
        else
            cat > "$FRONTEND_DIR/.env" << EOF
BACKEND_API_URL=http://localhost:5001
API_KEY=my-super-secret-api-key-2024
EOF
            print_success "Створено frontend/.env"
        fi
    else
        print_success "frontend/.env вже існує"
    fi
}

# Створення Docker network
create_network() {
    print_step "Створення Docker network..."
    
    if ! docker network inspect medical-network &> /dev/null; then
        docker network create medical-network
        print_success "Network 'medical-network' створено"
    else
        print_success "Network 'medical-network' вже існує"
    fi
}

# Запуск через Docker Compose
start_docker() {
    print_step "Запуск сервісів через Docker..."
    
    # Перевіряємо наявність docker-compose.yml
    if [ ! -f "$PROJECT_DIR/docker-compose.yml" ]; then
        print_error "docker-compose.yml не знайдено!"
        exit 1
    fi
    
    # Збірка та запуск
    echo ""
    print_step "Збірка Docker images..."
    docker-compose build
    
    echo ""
    print_step "Запуск контейнерів..."
    docker-compose up -d
    
    print_success "Контейнери запущено"
}

# Очікування готовності сервісів
wait_for_services() {
    print_step "Очікування готовності сервісів..."
    
    local max_attempts=30
    local attempt=1
    
    # Очікування Backend
    echo -n "  Backend: "
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:$BACKEND_PORT/health > /dev/null 2>&1; then
            echo -e "${GREEN}готовий${NC}"
            break
        fi
        echo -n "."
        sleep 1
        ((attempt++))
    done
    
    if [ $attempt -gt $max_attempts ]; then
        echo -e "${YELLOW}timeout (може ще запускатися)${NC}"
    fi
    
    # Очікування Frontend
    attempt=1
    echo -n "  Frontend: "
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:$FRONTEND_PORT > /dev/null 2>&1; then
            echo -e "${GREEN}готовий${NC}"
            break
        fi
        echo -n "."
        sleep 1
        ((attempt++))
    done
    
    if [ $attempt -gt $max_attempts ]; then
        echo -e "${YELLOW}timeout (може ще запускатися)${NC}"
    fi
}

# Виведення інформації про запущені сервіси
print_info() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           🚀 Сервіси запущено!             ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}                                            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Frontend (Streamlit):${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${BLUE}http://localhost:8501${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Backend API (Flask):${NC}                      ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${BLUE}http://localhost:5001${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${BLUE}http://localhost:5001/health${NC}              ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                            ${CYAN}║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${YELLOW}Команди:${NC}                                  ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  • Логи: ${BLUE}docker-compose logs -f${NC}            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  • Стоп: ${BLUE}./stop.sh${NC} або ${BLUE}docker-compose down${NC}${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  • Статус: ${BLUE}docker-compose ps${NC}               ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                            ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
    echo ""
}

# Відкриття браузера
open_browser() {
    read -p "Відкрити браузер? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sleep 2
        open "http://localhost:$FRONTEND_PORT"
    fi
}

# Показати допомогу
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  --help, -h     Показати цю допомогу"
    echo "  --stop         Зупинити всі сервіси"
    echo "  --restart      Перезапустити сервіси"
    echo "  --logs         Показати логи"
    echo "  --status       Статус контейнерів"
    echo "  --clean        Видалити контейнери та images"
    echo ""
}

# Зупинка сервісів
stop_services() {
    print_step "Зупинка сервісів..."
    cd "$PROJECT_DIR"
    docker-compose down
    print_success "Сервіси зупинено"
}

# Показати логи
show_logs() {
    cd "$PROJECT_DIR"
    docker-compose logs -f
}

# Статус
show_status() {
    cd "$PROJECT_DIR"
    docker-compose ps
}

# Очистка
clean_all() {
    print_step "Очистка..."
    cd "$PROJECT_DIR"
    docker-compose down --rmi all --volumes --remove-orphans
    print_success "Очищено"
}

# ============================================
# Main
# ============================================

main() {
    cd "$PROJECT_DIR"
    
    # Обробка аргументів
    case "${1:-}" in
        --help|-h)
            show_help
            exit 0
            ;;
        --stop)
            stop_services
            exit 0
            ;;
        --restart)
            stop_services
            echo ""
            ;;
        --logs)
            show_logs
            exit 0
            ;;
        --status)
            show_status
            exit 0
            ;;
        --clean)
            clean_all
            exit 0
            ;;
    esac
    
    print_header
    
    check_dependencies
    check_docker_running
    check_directories
    check_ports
    setup_env_files
    create_network
    
    echo ""
    start_docker
    
    echo ""
    wait_for_services
    
    print_info
    open_browser
}

main "$@"
