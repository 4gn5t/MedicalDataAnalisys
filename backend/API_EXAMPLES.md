# API Request Examples

## Base Configuration

```bash
API_KEY="my-super-secret-api-key-2024"
BASE_URL="http://127.0.0.1:8000"
```

---

## 1. Health Check

```bash
curl $BASE_URL/health
```

---

## 2. Predict - Healthy Patient

```bash
curl -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
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

## 3. Predict - Critical Patient (with Anomalies)

```bash
curl -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
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

---

## 4. Predict - With All Optional Fields

```bash
curl -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 45,
    "gender": "Female",
    "tsh_level": 3.2,
    "t3_level": 2.1,
    "t4_level": 9.5,
    "insulin": 15.3,
    "cortisol": 350.0,
    "testosterone": 2.5,
    "estrogen": 200.0,
    "hemoglobin": 135.0,
    "wbc": 7.2,
    "rbc": 4.8,
    "platelets": 250.0
  }'
```

---

## 5. Python Example

```python
import requests

API_KEY = "my-super-secret-api-key-2024"
BASE_URL = "http://127.0.0.1:8000"

# Health check
response = requests.get(f"{BASE_URL}/health")
print(response.json())

# Predict
data = {
    "age": 35,
    "gender": "Male",
    "tsh_level": 2.5,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
}

headers = {
    "X-API-Key": API_KEY,
    "Content-Type": "application/json"
}

response = requests.post(
    f"{BASE_URL}/api/v1/predict",
    json=data,
    headers=headers
)

print(response.json())
```

---

## 6. JavaScript (Node.js) Example

```javascript
const axios = require('axios');

const API_KEY = 'my-super-secret-api-key-2024';
const BASE_URL = 'http://127.0.0.1:8000';

// Health check
axios.get(`${BASE_URL}/health`)
  .then(response => console.log(response.data))
  .catch(error => console.error(error));

// Predict
const data = {
  age: 35,
  gender: 'Male',
  tsh_level: 2.5,
  t3_level: 2.0,
  t4_level: 8.0,
  insulin: 10.0
};

const config = {
  headers: {
    'X-API-Key': API_KEY,
    'Content-Type': 'application/json'
  }
};

axios.post(`${BASE_URL}/api/v1/predict`, data, config)
  .then(response => console.log(response.data))
  .catch(error => console.error(error));
```

---

## 7. Error Examples

### Missing API Key (401)

```bash
curl -X POST $BASE_URL/api/v1/predict \
  -H "Content-Type: application/json" \
  -d '{"age": 35, "gender": "Male", "tsh_level": 2.5, "t3_level": 2.0, "t4_level": 8.0, "insulin": 10.0}'
```

### Wrong API Key (403)

```bash
curl -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: wrong-key" \
  -H "Content-Type: application/json" \
  -d '{"age": 35, "gender": "Male", "tsh_level": 2.5, "t3_level": 2.0, "t4_level": 8.0, "insulin": 10.0}'
```

### Invalid Data (400)

```bash
curl -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"age": -5, "gender": "Unknown"}'
```

---

## 8. Postman Collection

Import this JSON into Postman:

```json
{
  "info": {
    "name": "Medical Analysis API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Health Check",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "{{BASE_URL}}/health",
          "host": ["{{BASE_URL}}"],
          "path": ["health"]
        }
      }
    },
    {
      "name": "Predict - Healthy",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "X-API-Key",
            "value": "{{API_KEY}}",
            "type": "text"
          },
          {
            "key": "Content-Type",
            "value": "application/json",
            "type": "text"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"age\": 35,\n  \"gender\": \"Male\",\n  \"tsh_level\": 2.5,\n  \"t3_level\": 2.0,\n  \"t4_level\": 8.0,\n  \"insulin\": 10.0\n}"
        },
        "url": {
          "raw": "{{BASE_URL}}/api/v1/predict",
          "host": ["{{BASE_URL}}"],
          "path": ["api", "v1", "predict"]
        }
      }
    }
  ],
  "variable": [
    {
      "key": "BASE_URL",
      "value": "http://127.0.0.1:8000"
    },
    {
      "key": "API_KEY",
      "value": "my-super-secret-api-key-2024"
    }
  ]
}
```

Save as `medical-api.postman_collection.json`

