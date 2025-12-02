#!/bin/bash

# Кольори
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Backend Connection Test                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}\n"

# Читаємо BACKEND_API_URL з .env
if [ -f ".env" ]; then
    BACKEND_URL=$(grep BACKEND_API_URL .env | cut -d '=' -f2)
    API_KEY=$(grep API_KEY .env | cut -d '=' -f2)
else
    echo -e "${RED}✗ .env file not found!${NC}"
    exit 1
fi

echo -e "${YELLOW}Backend URL: $BACKEND_URL${NC}"
echo -e "${YELLOW}API Key: ${API_KEY:0:10}...${NC}\n"

# Test 1: Health Check
echo -e "${BLUE}[TEST 1]${NC} ${YELLOW}Health Check${NC}"
response=$(curl -s "$BACKEND_URL/health")

if echo "$response" | grep -q "ok"; then
    echo -e "${GREEN}✓ PASSED${NC}"
    echo "Response: $response"
else
    echo -e "${RED}✗ FAILED${NC}"
    echo "Response: $response"
fi

echo ""

# Test 2: Predict with API Key
echo -e "${BLUE}[TEST 2]${NC} ${YELLOW}Predict Request (with API Key)${NC}"
response=$(curl -s -X POST "$BACKEND_URL/api/v1/predict" \
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

if echo "$response" | grep -q "status"; then
    echo -e "${GREEN}✓ PASSED${NC}"
    echo "Response: $response"
else
    echo -e "${RED}✗ FAILED${NC}"
    echo "Response: $response"
fi

echo ""

# Test 3: Predict without API Key (should fail)
echo -e "${BLUE}[TEST 3]${NC} ${YELLOW}Predict Request (without API Key - should fail)${NC}"
response=$(curl -s -X POST "$BACKEND_URL/api/v1/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "gender": "Male",
    "tsh_level": 2.5,
    "t3_level": 2.0,
    "t4_level": 8.0,
    "insulin": 10.0
  }')

if echo "$response" | grep -q "error"; then
    echo -e "${GREEN}✓ PASSED (correctly rejected)${NC}"
    echo "Response: $response"
else
    echo -e "${RED}✗ FAILED (should have been rejected)${NC}"
    echo "Response: $response"
fi

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Connection Test Complete          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"

