# 🏥 Medical Analysis Backend API

REST API для прогнозування стану здоров'я пацієнтів на основі гормональних та гематологічних показників.

---

## 📋 Зміст

- [Можливості](#можливості)
- [Технології](#технології)
- [Встановлення](#встановлення)
- [Запуск проекту](#запуск-проекту)
- [Тестування](#тестування)
- [API Endpoints](#api-endpoints)
- [Swagger Документація](#swagger-документація)
- [Docker](#docker)
- [Структура проекту](#структура-проекту)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Можливості

- ✅ Прогнозування стану здоров'я (Healthy / Warning / Moderate Risk / Critical)
- ✅ Виявлення аномальних показників
- ✅ Розрахунок ймовірності ризику
- ✅ API Key автентифікація
- ✅ Rate Limiting (захист від DDoS)
- ✅ Swagger/OpenAPI документація
- ✅ Автоматичне логування
- ✅ CORS підтримка
- ✅ Валідація даних через Pydantic
- ✅ Error handling

---

## 🛠 Технології

- **Flask 3.1.2** — веб-фреймворк
- **Pydantic 2.12.5** — валідація даних
- **Flask-CORS 6.0.1** — підтримка Cross-Origin запитів
- **Flask-Limiter 3.5.1** — обмеження кількості запитів
- **Flasgger 0.9.7.1** — Swagger/OpenAPI документація
- **Pytest 7.4.3** — тестування
- **Python-dotenv 1.0.0** — змінні середовища
- **Docker** — контейнеризація

---

## 📦 Встановлення

### 1️⃣ Клонування репозиторію

```bash
git clone https://github.com/yourusername/MedicalDataAnalisys.git
cd MedicalDataAnalisys
git checkout backend  # Перемикаємося на гілку backend
```

### 2️⃣ Перехід до папки backend

```bash
cd backend
```

### 3️⃣ Створення віртуального середовища

```bash
python3 -m venv .venv
```

### 4️⃣ Активація віртуального середовища

**macOS/Linux:**
```bash
source .venv/bin/activate
```

**Windows:**
```bash
.venv\Scripts\activate
```

### 5️⃣ Оновлення pip

```bash
python -m pip install --upgrade pip
```

### 6️⃣ Встановлення залежностей

```bash
python -m pip install -r requirements.txt
```

### 7️⃣ Створення файлу .env

Створіть файл `.env` у папці `backend/`:

```bash
touch .env
```

Додайте наступний вміст:

```env
# Flask Configuration
FLASK_ENV=development
FLASK_DEBUG=True
SECRET_KEY=your-secret-key-change-in-production-12345

# API Security
API_KEY=my-super-secret-api-key-2024

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8501,http://localhost:8000

# Logging
LOG_LEVEL=INFO
```

---

## 🚀 Запуск проекту

### Варіант 1: Через Flask CLI (рекомендовано)

```bash
cd backend
source .venv/bin/activate
export FLASK_APP=app.py
python -m flask run --host=127.0.0.1 --port=8000
```

### Варіант 2: Через Python модуль

```bash
cd backend
source .venv/bin/activate
python -m flask run --port=8000
```

### Варіант 3: Прямий запуск скрипта

```bash
cd backend
source .venv/bin/activate
python app.py
```

### ✅ Перевірка запуску

Сервер запуститься на `http://127.0.0.1:8000`

Відкрийте у браузері або curl:

```bash
curl http://127.0.0.1:8000/health
```

**Очікувана відповідь:**
```json
{
  "status": "ok",
  "service": "backend-medical-analysis",
  "version": "1.0.0"
}
```

---

## 🧪 Тестування

### 1️⃣ Запуск усіх тестів

```bash
cd backend
source .venv/bin/activate
python -m pytest tests/ -v
```

**Очікуваний результат:**
```
tests/test_api.py::test_health_check PASSED
tests/test_api.py::test_predict_valid_data PASSED
tests/test_api.py::test_predict_invalid_data PASSED
```

### 2️⃣ Запуск конкретного тесту

```bash
python -m pytest tests/test_api.py::test_health_check -v
```

### 3️⃣ Тести з покриттям коду

```bash
python -m pip install pytest-cov
python -m pytest tests/ --cov=. --cov-report=html
```

Звіт буде у `htmlcov/index.html` — відкрийте у браузері.

### 4️⃣ Тести з детальним виводом

```bash
python -m pytest tests/ -v --tb=short
```

---

## 📖 Swagger Документація

### Доступ до Swagger UI

Після запуску сервера відкрийте у браузері:

```
http://127.0.0.1:8000/api/docs
```

### Автентифікація у Swagger

1. Натисніть кнопку **🔒 Authorize** (у правому верхньому куті)
2. У полі **Value** введіть ваш API ключ:
   ```
   my-super-secret-api-key-2024
   ```
3. Натисніть **Authorize** → **Close**
4. Тепер можете тестувати endpoints прямо з інтерфейсу!

### Тестування через Swagger

1. Розгорніть endpoint `POST /api/v1/predict`
2. Натисніть **Try it out**
3. Введіть тестові дані:
   ```json
   {
     "age": 35,
     "gender": "Male",
     "tsh_level": 2.5,
     "t3_level": 2.0,
     "t4_level": 8.0,
     "insulin": 10.0
   }
   ```
4. Натисніть **Execute**
5. Перегляньте відповідь сервера

---

## 🔌 API Endpoints

### 1️⃣ Health Check

**Endpoint:** `GET /health`

**Curl:**
```bash
curl http://127.0.0.1:8000/health
```

**Відповідь:**
```json
{
  "status": "ok",
  "service": "backend-medical-analysis",
  "version": "1.0.0"
}
```

---

### 2️⃣ Прогнозування (з нормальними показниками)

**Endpoint:** `POST /api/v1/predict`

**Headers:**
- `Content-Type: application/json`
- `X-API-Key: my-super-secret-api-key-2024`

**Curl:**
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
    "insulin": 10.0,
    "hemoglobin": 145.0,
    "wbc": 7.5,
    "rbc": 5.0,
    "platelets": 250.0
  }'
```

**Відповідь:**
```json
{
  "status": "Healthy",
  "risk_probability": 8.32,
  "recommendation": "Усі показники в нормі. Продовжуйте дотримуватися здорового способу життя.",
  "anomalies": [],
  "confidence": 92.14
}
```

---

### 3️⃣ Прогнозування (з аномаліями)

**Curl:**
```bash
curl -X POST http://127.0.0.1:8000/api/v1/predict \
  -H "X-API-Key: my-super-secret-api-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 65,
    "gender": "Female",
    "tsh_level": 12.5,
    "t3_level": 0.8,
    "t4_level": 3.0,
    "insulin": 50.0
  }'
```

**Відповідь:**
```json
{
  "status": "Critical",
  "risk_probability": 78.45,
  "recommendation": "Виявлено критичні відхилення! Терміново зверніться до лікаря!",
  "anomalies": [
    "High TSH_LEVEL: 12.5",
    "Low T3_LEVEL: 0.8",
    "Low T4_LEVEL: 3.0",
    "High INSULIN: 50.0"
  ],
  "confidence": 87.23
}
```

---

### 4️⃣ Тестування помилок

#### ❌ Без API ключа (401 Unauthorized)

```bash
curl -X POST http://127.0.0.1:8000/api/v1/predict \
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

**Відповідь:**
```json
{
  "error": "API Key відсутній"
}
```

#### ❌ Невалідні дані (400 Bad Request)

```bash
curl -X POST http://127.0.0.1:8000/api/v1/predict \
  -H "X-API-Key: my-super-secret-api-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "age": -5,
    "gender": "Unknown",
    "tsh_level": 200
  }'
```

#### ❌ Перевищення ліміту (429 Too Many Requests)

```bash
# Запустіть 11 запитів підряд (ліміт: 10 за хвилину)
for i in {1..11}; do
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
  echo "\n--- Request $i ---"
  sleep 1
done
```

**11-й запит поверне:**
```json
{
  "error": "429 Too Many Requests: 10 per 1 minute"
}
```

---

## 🧾 Shell Скрипти для Тестування

### Створення скрипта для повного тестування

Створіть файл `test_all.sh` у папці `backend/`:

```bash
#!/bin/bash

# Кольори для виводу
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

API_KEY="my-super-secret-api-key-2024"
BASE_URL="http://127.0.0.1:8000"

echo -e "${YELLOW}=== Medical Analysis API Tests ===${NC}\n"

# 1. Health Check
echo -e "${YELLOW}[TEST 1] Health Check${NC}"
response=$(curl -s $BASE_URL/health)
if echo $response | grep -q "ok"; then
  echo -e "${GREEN}✓ PASSED${NC}\n"
else
  echo -e "${RED}✗ FAILED${NC}\n"
fi

# 2. Predict - Valid Data
echo -e "${YELLOW}[TEST 2] Predict with Valid Data${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "gender": "Male",
    "tsh_level": 2.5,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
  }')
if echo $response | grep -q "status"; then
  echo -e "${GREEN}✓ PASSED${NC}"
  echo "Response: $response\n"
else
  echo -e "${RED}✗ FAILED${NC}\n"
fi

# 3. Predict - Anomalies
echo -e "${YELLOW}[TEST 3] Predict with Anomalies${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 65,
    "gender": "Female",
    "tsh_level": 12.5,
    "t3_level": 0.8,
    "t4_level": 3.0,
    "insulin": 50.0
  }')
if echo $response | grep -q "Critical"; then
  echo -e "${GREEN}✓ PASSED${NC}"
  echo "Response: $response\n"
else
  echo -e "${RED}✗ FAILED${NC}\n"
fi

# 4. Predict - No API Key (should fail)
echo -e "${YELLOW}[TEST 4] Predict without API Key (should fail)${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "gender": "Male",
    "tsh_level": 2.5,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
  }')
if echo $response | grep -q "API Key відсутній"; then
  echo -e "${GREEN}✓ PASSED (correctly rejected)${NC}\n"
else
  echo -e "${RED}✗ FAILED${NC}\n"
fi

# 5. Predict - Invalid Data (should fail)
echo -e "${YELLOW}[TEST 5] Predict with Invalid Data (should fail)${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "age": -5,
    "gender": "Unknown"
  }')
if echo $response | grep -q "error"; then
  echo -e "${GREEN}✓ PASSED (correctly rejected)${NC}\n"
else
  echo -e "${RED}✗ FAILED${NC}\n"
fi

echo -e "${YELLOW}=== All Tests Completed ===${NC}"
```

### Зробіть скрипт виконуваним:

```bash
chmod +x test_all.sh
```

### Запуск тестів:

```bash
./test_all.sh
```

---

## 🐳 Docker

### Запуск через Docker Compose

```bash
cd backend
docker-compose up --build
```

Сервер буде доступний на `http://localhost:5000`

### Окремий запуск Docker

```bash
cd backend
docker build -t medical-backend .
docker run -p 8000:8000 \
  -e API_KEY=my-super-secret-api-key-2024 \
  -e FLASK_ENV=development \
  medical-backend
```

### Зупинка Docker

```bash
docker-compose down
```

---

## 📁 Структура проекту

```
backend/
├── app.py                  # Головний Flask додаток
├── config.py               # Конфігурація (dev/prod)
├── requirements.txt        # Python залежності
├── Dockerfile              # Docker образ
├── docker-compose.yml      # Docker Compose конфігурація
├── .env                    # Змінні середовища (не в git!)
├── README.md               # Документація (цей файл)
├── test_all.sh             # Shell скрипт для тестування
│
├── logs/                   # Логи сервера
│   └── backend.log
│
├── middleware/             # Middleware (auth, logging)
│   ├── __init__.py
│   └── auth.py             # API ключ автентифікація
│
├── models/                 # Моделі даних
│   ├── __init__.py
│   ├── schemas.py          # Pydantic моделі для валідації
│   └── database.py         # SQLAlchemy моделі (майбутнє)
│
├── routes/                 # API endpoints
│   ├── __init__.py
│   └── analysis.py         # /predict endpoint
│
├── services/               # Бізнес-логіка
│   ├── __init__.py
│   ├── mock_ml.py          # Mock ML сервіс (поточний)
│   └── ml_inference.py     # Реальні ML моделі (майбутнє)
│
├── tests/                  # Тести
│   ├── __init__.py
│   └── test_api.py         # Pytest тести
│
└── utils/                  # Утиліти
    ├── __init__.py
    └── errors.py           # Error handlers
```

---

## 🔒 Безпека

### Rate Limiting

- **Глобальні ліміти:** 200 запитів/день, 50 запитів/година
- **Endpoint `/predict`:** 10 запитів/хвилину на IP-адресу

### Автентифікація

Усі запити до `/api/v1/predict` вимагають header:
```
X-API-Key: your-api-key-here
```

### CORS

Дозволені домени налаштовуються у `.env`:
```env
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8501
```

---

## 📊 Логування

Логи зберігаються у `backend/logs/backend.log`

### Перегляд логів у реальному часі:

```bash
tail -f logs/backend.log
```

### Налаштування:
- **Макс. розмір файлу:** 10KB
- **Backup файли:** 3 штуки
- **Рівень логування:** INFO (змінюється у `.env`)

---

## 🐛 Troubleshooting

### ❌ Порт зайнятий

```bash
# Знайти процес на порту 8000
lsof -ti :8000

# Вбити процес
lsof -ti :8000 | xargs kill -9

# Або запустити на іншому порті
python -m flask run --port=8001
```

### ❌ Помилка імпорту модулів

```bash
# Перевірте, що знаходитесь у правильній директорії
pwd  # Має бути .../MedicalDataAnalisys/backend

# Активуйте віртуальне середовище
source .venv/bin/activate

# Переінсталюйте залежності
python -m pip install -r requirements.txt --force-reinstall
```

### ❌ ModuleNotFoundError: No module named 'backend'

Запускайте з КОРЕНЕВОЇ папки проекту:

```bash
cd /path/to/MedicalDataAnalisys  # НЕ backend/
source backend/.venv/bin/activate
PYTHONPATH=. python backend/app.py
```

Або з папки `backend/` через відносні імпорти (файли вже налаштовані).

### ❌ Swagger не відображається

```bash
# Перевірте встановлення flasgger
python -m pip install flasgger==0.9.7.1

# Перевірте версію
python -m pip freeze | grep -i flasgger
```

### ❌ Тести не проходять

```bash
# Встановіть pytest
python -m pip install pytest pytest-flask

# Запустіть з детальним виводом
python -m pytest tests/ -vv --tb=long

# Перевірте, що сервер НЕ запущений під час pytest
lsof -ti :8000 | xargs kill -9
```

### ❌ API Key не працює

Перевірте файл `.env`:

```bash
cat .env | grep API_KEY
```

Має бути:
```
API_KEY=my-super-secret-api-key-2024
```

Перезапустіть сервер після зміни `.env`.

---

## 📚 Додаткові ресурси

### Валідація даних (Pydantic)

Усі поля перевіряються автоматично:

- **age:** 1-120 років
- **gender:** "Male" або "Female"
- **tsh_level:** 0-100 mIU/L
- **t3_level:** 0-10 nmol/L
- **t4_level:** 0-25 pmol/L
- **insulin:** 0-300 pmol/L

Опційні поля: `cortisol`, `testosterone`, `estrogen`, `hemoglobin`, `wbc`, `rbc`, `platelets`

### Нормальні діапазони (використовуються у Mock ML)

| Показник | Норма |
|----------|-------|
| TSH | 0.4 - 4.0 mIU/L |
| T3 | 1.3 - 3.1 nmol/L |
| T4 | 5.0 - 12.0 pmol/L |
| Insulin | 2.6 - 24.9 pmol/L |
| Hemoglobin | 120 - 160 g/L |
| WBC | 4.0 - 11.0 ×10⁹/L |
| RBC | 4.0 - 6.0 ×10¹²/L |
| Platelets | 150 - 400 ×10⁹/L |

---


