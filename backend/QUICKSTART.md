# 🚀 Quick Start Guide

## Швидкий запуск за 3 хвилини

### 1️⃣ Встановлення (один раз)

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
cp .env.example .env
```

### 2️⃣ Запуск сервера

**Варіант A: Через скрипт (найпростіше)**
```bash
./start_server.sh
```

**Варіант B: Вручну**
```bash
cd backend
source .venv/bin/activate
python app.py
```

Сервер запуститься на `http://127.0.0.1:8000`

### 3️⃣ Перевірка

```bash
curl http://127.0.0.1:8000/health
```

### 4️⃣ Swagger Документація

Відкрий у браузері:
```
http://127.0.0.1:8000/api/docs
```

**Автентифікація:**
- Натисни 🔒 Authorize
- Введи: `my-super-secret-api-key-2024`

---

## 🧪 Тестування

### Pytest (unit тести)
```bash
./run_pytest.sh
```

### Shell тести (integration)
```bash
./test_all.sh
```

---

## 📝 Тестовий запит

```bash
curl -X POST http://127.0.0.1:8000/api/v1/predict \
  -H "X-API-Key: my-super-secret-api-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "gender": "Male",
    "tsh_level": 2.5,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
  }'
```

---

## 🐳 Docker (альтернатива)

```bash
cd backend
docker-compose up --build
```

---

## 📖 Повна документація

Дивись [README.md](README.md)

---

## ⚡ Команди

| Команда | Опис |
|---------|------|
| `./start_server.sh` | Запустити сервер |
| `./run_pytest.sh` | Запустити unit тести |
| `./test_all.sh` | Запустити integration тести |
| `python app.py` | Запуск сервера вручну |
| `python -m pytest tests/ -v` | Pytest з деталями |

---

## 🆘 Проблеми?

**Порт зайнятий:**
```bash
lsof -ti :8000 | xargs kill -9
```

**Помилки імпорту:**
```bash
source .venv/bin/activate
python -m pip install -r requirements.txt --force-reinstall
```

**Сервер не запускається:**
- Перевір чи активоване віртуальне середовище
- Перевір чи існує `.env` файл
- Перевір логи у `logs/backend.log`

---

**Готово! Backend працює! 🎉**

