import os
from functools import wraps
from flask import request, jsonify


def require_api_key(f):
    """Декоратор для перевірки API ключа"""

    @wraps(f)
    def decorated(*args, **kwargs):
        api_key = request.headers.get('X-API-Key')
        expected_key = os.getenv('API_KEY', 'dev-api-key-12345')

        if not api_key:
            return jsonify({"error": "API Key відсутній"}), 401

        if api_key != expected_key:
            return jsonify({"error": "Невірний API Key"}), 403

        return f(*args, **kwargs)

    return decorated
