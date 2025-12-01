# 🚀 Quick Start Guide - Frontend

## Швидкий запуск за 3 хвилини

### 1️⃣ Встановлення (один раз)

```bash
cd frontend
python3 -m venv .venv
source .venv/bin/activate  # macOS/Linux
# або .venv\Scripts\activate  # Windows
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

### 2️⃣ Перевірка .env файлу

```bash
cat .env
```

Має містити:
```env
BACKEND_API_URL=http://localhost:8000
API_KEY=my-super-secret-api-key-2024
STREAMLIT_SERVER_PORT=8501
STREAMLIT_SERVER_ADDRESS=0.0.0.0
```

### 3️⃣ Запуск Backend (в окремому терміналі)

```bash
cd backend
source .venv/bin/activate
python app.py
```

Backend має запуститись на `http://localhost:8000`

### 4️⃣ Запуск Frontend

**Варіант A: Через скрипт (найпростіше)**
```bash
cd frontend
./scripts/start_frontend.sh
```

**Варіант B: Вручну**
```bash
cd frontend
source .venv/bin/activate
streamlit run app.py
```

Frontend запуститься на `http://localhost:8501`

### 5️⃣ Перевірка

1. Відкрий браузер: `http://localhost:8501`
2. Перевір sidebar — має бути **✅ Backend підключено**
3. Перейди на **📊 Single Analysis**
4. Заповни форму і натисни **🔍 Провести аналіз**

---

## 🧪 Швидкий тест

### Тест 1: Single Analysis

1. Відкрий `http://localhost:8501/Single_Analysis`
2. Введи дані:
   - Вік: 35
   - Стать: Male
   - TSH: 2.5
   - T3: 2.0
   - T4: 8.0
   - Інсулін: 10.0
3. Натисни **Провести аналіз**
4. Маєш побачити статус **Healthy** 🟢

### Тест 2: Batch Analysis

1. Відкрий `http://localhost:8501/Batch_Analysis`
2. Завантаж тестовий CSV:

Створи файл `test_patients.csv`:
```csv
age,gender,tsh_level,t3_level,t4_level,insulin
35,Male,2.5,2.0,8.0,10.0
65,Female,12.5,0.8,3.0,50.0
```

3. Завантаж файл через інтерфейс
4. Натисни **Аналізувати всіх пацієнтів**
5. Маєш побачити таблицю з 2 результатами

---

## ⚡ Команди

| Команда | Опис |
|---------|------|
| `./scripts/start_frontend.sh` | Запустити frontend |
| `./scripts/test_connection.sh` | Тест підключення до backend |
| `streamlit run app.py` | Запуск вручну |
| `streamlit run app.py --server.port=8502` | Запуск на іншому порті |
| `streamlit cache clear` | Очистити кеш |

---

## 🆘 Проблеми?

**Backend недоступний:**
```bash
# Перевір чи запущений backend
curl http://localhost:8000/health

# Якщо ні, запусти
cd ../backend && python app.py
```

**Порт зайнятий:**
```bash
lsof -ti :8501 | xargs kill -9
streamlit run app.py --server.port=8502
```

**Помилки імпорту:**
```bash
source .venv/bin/activate
python -m pip install -r requirements.txt --force-reinstall
```

---

## 📖 Повна документація

Дивись [README.md](README.md)

---

**Готово! Frontend працює! 🎉**

Відкрий `http://localhost:8501` і починай аналізувати! 🏥

