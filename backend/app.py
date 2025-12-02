from flask import Flask
from flask_cors import CORS
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flasgger import Swagger
from routes.analysis import analysis_bp
from utils.errors import register_error_handlers
from config import config
import os
import logging
from logging.handlers import RotatingFileHandler


def setup_logging(app):
    os.makedirs('logs', exist_ok=True)
    handler = RotatingFileHandler('logs/backend.log', maxBytes=10000, backupCount=3)
    handler.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    app.logger.addHandler(handler)


def create_app(config_name=None):
    app = Flask(__name__)

    config_name = config_name or os.getenv('FLASK_ENV', 'development')
    app.config.from_object(config[config_name])

    CORS(app, origins=app.config['ALLOWED_ORIGINS'])
    logging.basicConfig(level=app.config['LOG_LEVEL'])
    setup_logging(app)

    # Rate Limiting
    limiter = Limiter(
        app=app,
        key_func=get_remote_address,
        default_limits=["200 per day", "50 per hour"],
        storage_uri="memory://"
    )

    # Swagger
    swagger_config = {
        "headers": [],
        "specs": [
            {
                "endpoint": 'apispec',
                "route": '/apispec.json',
                "rule_filter": lambda rule: True,
                "model_filter": lambda tag: True,
            }
        ],
        "static_url_path": "/flasgger_static",
        "swagger_ui": True,
        "specs_route": "/api/docs"
    }

    swagger_template = {
        "info": {
            "title": "Medical Analysis API",
            "description": "API для прогнозування стану здоров'я пацієнтів",
            "version": "1.0.0"
        },
        "securityDefinitions": {
            "ApiKeyAuth": {
                "type": "apiKey",
                "name": "X-API-Key",
                "in": "header"
            }
        },
        "security": [{"ApiKeyAuth": []}]
    }

    Swagger(app, config=swagger_config, template=swagger_template)

    register_error_handlers(app)
    app.register_blueprint(analysis_bp, url_prefix='/api/v1')

    @app.route('/health')
    def health_check():
        """
        Health Check
        ---
        responses:
          200:
            description: Статус сервера
        """
        return {
            "status": "ok",
            "service": "backend-medical-analysis",
            "version": "1.0.0"
        }

    return app


if __name__ == '__main__':
    app = create_app()
    app.run(debug=True, host='0.0.0.0', port=8000)