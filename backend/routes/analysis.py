from flask import Blueprint, request, jsonify
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from pydantic import ValidationError
from models.schemas import PatientData
from services.mock_ml import predict_health_status
from middleware.auth import require_api_key

analysis_bp = Blueprint('analysis', __name__)

limiter = Limiter(
    key_func=get_remote_address,
    storage_uri="memory://"
)


@analysis_bp.route('/predict', methods=['POST'])
@require_api_key
@limiter.limit("10 per minute")
def analyze_patient():
    """
    Прогнозування стану пацієнта
    ---
    tags:
      - Predictions
    parameters:
      - name: X-API-Key
        in: header
        type: string
        required: true
        description: API ключ для автентифікації
      - name: body
        in: body
        required: true
        schema:
          type: object
          required:
            - age
            - gender
            - tsh_level
            - t3_level
            - t4_level
            - insulin
          properties:
            age:
              type: integer
              example: 35
            gender:
              type: string
              enum: [Male, Female]
              example: Male
            tsh_level:
              type: number
              example: 2.5
            t3_level:
              type: number
              example: 2.0
            t4_level:
              type: number
              example: 8.0
            insulin:
              type: number
              example: 10.0
            hemoglobin:
              type: number
              example: 140.0
    responses:
      200:
        description: Успішний прогноз
        schema:
          type: object
          properties:
            status:
              type: string
              example: Healthy
            risk_probability:
              type: number
              example: 5.23
            recommendation:
              type: string
              example: Усі показники в нормі
            anomalies:
              type: array
              items:
                type: string
            confidence:
              type: number
              example: 89.45
      400:
        description: Невалідні дані
      401:
        description: Відсутній API ключ
      403:
        description: Невірний API ключ
      429:
        description: Перевищено ліміт запитів
    """
    try:
        data = request.json
        patient = PatientData(**data)
        result = predict_health_status(patient.model_dump())
        return jsonify(result), 200

    except ValidationError as e:
        return jsonify({"error": e.errors()}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500
