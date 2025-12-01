import pytest
import os
import sys
from pathlib import Path

# Додаємо backend папку до PYTHONPATH
sys.path.insert(0, str(Path(__file__).parent.parent))

from app import create_app


@pytest.fixture
def client():
    """Фікстура для тестового клієнта"""
    os.environ['API_KEY'] = 'test-api-key-12345'
    app = create_app('development')
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_health_check(client):
    """Тест health check endpoint (без автентифікації)"""
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json['status'] == 'ok'
    assert response.json['service'] == 'backend-medical-analysis'


def test_predict_valid_data(client):
    """Тест прогнозування з валідними даними"""
    data = {
        "age": 35,
        "gender": "Male",
        "tsh_level": 2.5,
        "t3_level": 2.0,
        "t4_level": 8.0,
        "insulin": 10.0
    }
    response = client.post(
        '/api/v1/predict',
        json=data,
        headers={'X-API-Key': 'test-api-key-12345'}
    )
    assert response.status_code == 200
    assert 'status' in response.json
    assert 'risk_probability' in response.json
    assert 'recommendation' in response.json
    assert 'anomalies' in response.json
    assert 'confidence' in response.json


def test_predict_with_anomalies(client):
    """Тест прогнозування з аномальними показниками"""
    data = {
        "age": 65,
        "gender": "Female",
        "tsh_level": 12.5,
        "t3_level": 0.8,
        "t4_level": 3.0,
        "insulin": 50.0
    }
    response = client.post(
        '/api/v1/predict',
        json=data,
        headers={'X-API-Key': 'test-api-key-12345'}
    )
    assert response.status_code == 200
    assert len(response.json['anomalies']) > 0


def test_predict_invalid_data(client):
    """Тест прогнозування з невалідними даними"""
    data = {"age": -5, "gender": "Unknown"}
    response = client.post(
        '/api/v1/predict',
        json=data,
        headers={'X-API-Key': 'test-api-key-12345'}
    )
    assert response.status_code == 400
    assert 'error' in response.json


def test_predict_no_api_key(client):
    """Тест без API ключа (має повернути 401)"""
    data = {
        "age": 35,
        "gender": "Male",
        "tsh_level": 2.5,
        "t3_level": 2.0,
        "t4_level": 8.0,
        "insulin": 10.0
    }
    response = client.post('/api/v1/predict', json=data)
    assert response.status_code == 401
    assert 'error' in response.json


def test_predict_wrong_api_key(client):
    """Тест з невірним API ключем (має повернути 403)"""
    data = {
        "age": 35,
        "gender": "Male",
        "tsh_level": 2.5,
        "t3_level": 2.0,
        "t4_level": 8.0,
        "insulin": 10.0
    }
    response = client.post(
        '/api/v1/predict',
        json=data,
        headers={'X-API-Key': 'wrong-key'}
    )
    assert response.status_code == 403
    assert 'error' in response.json


def test_predict_missing_required_field(client):
    """Тест з відсутніми обов'язковими полями"""
    data = {
        "age": 35,
        "gender": "Male",
        "tsh_level": 2.5
        # Пропущені t3_level, t4_level, insulin
    }
    response = client.post(
        '/api/v1/predict',
        json=data,
        headers={'X-API-Key': 'test-api-key-12345'}
    )
    assert response.status_code == 400


def test_predict_out_of_range(client):
    """Тест зі значеннями поза діапазоном"""
    data = {
        "age": 150,  # Більше 120
        "gender": "Male",
        "tsh_level": 2.5,
        "t3_level": 2.0,
        "t4_level": 8.0,
        "insulin": 10.0
    }
    response = client.post(
        '/api/v1/predict',
        json=data,
        headers={'X-API-Key': 'test-api-key-12345'}
    )
    assert response.status_code == 400