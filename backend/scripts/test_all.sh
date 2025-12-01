#!/bin/bash

# Кольори для виводу
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

API_KEY="my-super-secret-api-key-2024"
BASE_URL="http://127.0.0.1:8000"

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Medical Analysis API - Test Suite       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"

# Перевірка чи запущений сервер
echo -e "${YELLOW}Checking if server is running...${NC}"
if ! curl -s $BASE_URL/health > /dev/null 2>&1; then
    echo -e "${RED}✗ Server is not running!${NC}"
    echo -e "${YELLOW}Please start the server first:${NC}"
    echo -e "  cd backend"
    echo -e "  source .venv/bin/activate"
    echo -e "  python app.py"
    exit 1
fi
echo -e "${GREEN}✓ Server is running${NC}\n"

# Лічильник тестів
PASSED=0
FAILED=0
TOTAL=0

# Функція для виведення результату
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASSED${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAILED${NC}"
        ((FAILED++))
    fi
    ((TOTAL++))
    echo ""
}

# ═══════════════════════════════════════════
# TEST 1: Health Check
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 1]${NC} ${YELLOW}Health Check${NC}"
response=$(curl -s $BASE_URL/health)
echo "Response: $response"
if echo $response | grep -q "ok"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 2: Predict - Valid Data (Healthy)
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 2]${NC} ${YELLOW}Predict with Valid Data (Healthy Patient)${NC}"
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
echo "Response: $response"
if echo $response | grep -q "status"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 3: Predict - With Anomalies (Critical)
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 3]${NC} ${YELLOW}Predict with Anomalies (Critical Patient)${NC}"
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
echo "Response: $response"
if echo $response | grep -q "Critical"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 4: Predict - With All Optional Fields
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 4]${NC} ${YELLOW}Predict with All Optional Fields${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
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
  }')
echo "Response: $response"
if echo $response | grep -q "status"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 5: Error - No API Key (401)
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 5]${NC} ${YELLOW}Predict without API Key (should fail with 401)${NC}"
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
echo "Response: $response"
if echo $response | grep -q "API Key відсутній"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 6: Error - Wrong API Key (403)
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 6]${NC} ${YELLOW}Predict with Wrong API Key (should fail with 403)${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: wrong-key-12345" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "gender": "Male",
    "tsh_level": 2.5,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
  }')
echo "Response: $response"
if echo $response | grep -q "Невірний API Key"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 7: Error - Invalid Age (400)
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 7]${NC} ${YELLOW}Predict with Invalid Age (should fail with 400)${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "age": -5,
    "gender": "Male",
    "tsh_level": 2.5,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
  }')
echo "Response: $response"
if echo $response | grep -q "error"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 8: Error - Invalid Gender (400)
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 8]${NC} ${YELLOW}Predict with Invalid Gender (should fail with 400)${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "gender": "Unknown",
    "tsh_level": 2.5,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
  }')
echo "Response: $response"
if echo $response | grep -q "error"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 9: Error - Missing Required Field (400)
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 9]${NC} ${YELLOW}Predict with Missing Required Field (should fail with 400)${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "gender": "Male",
    "tsh_level": 2.5
  }')
echo "Response: $response"
if echo $response | grep -q "error"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# TEST 10: Error - Out of Range Value (400)
# ═══════════════════════════════════════════
echo -e "${BLUE}[TEST 10]${NC} ${YELLOW}Predict with Out of Range TSH (should fail with 400)${NC}"
response=$(curl -s -X POST $BASE_URL/api/v1/predict \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "gender": "Male",
    "tsh_level": 150,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
  }')
echo "Response: $response"
if echo $response | grep -q "error"; then
    print_result 0
else
    print_result 1
fi

# ═══════════════════════════════════════════
# РЕЗУЛЬТАТИ
# ═══════════════════════════════════════════
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            Test Results Summary            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo -e "Total:  $TOTAL"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed! 🎉${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Some tests failed!${NC}"
    exit 1
fi

