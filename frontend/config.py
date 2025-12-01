import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    BACKEND_API_URL = os.getenv('BACKEND_API_URL', 'http://localhost:8000')
    API_KEY = os.getenv('API_KEY', 'dev-api-key-12345')
    STREAMLIT_SERVER_PORT = int(os.getenv('STREAMLIT_SERVER_PORT', 8501))
    STREAMLIT_SERVER_ADDRESS = os.getenv('STREAMLIT_SERVER_ADDRESS', '0.0.0.0')

    # Референтні норми
    NORMAL_RANGES = {
        'TSH': (0.4, 4.0, 'мкМО/мл'),
        'T3': (1.3, 3.1, 'нмоль/л'),
        'T4': (5.0, 12.0, 'мкг/дл'),
        'Insulin': (2.6, 24.9, 'мкМО/мл'),
        'Hemoglobin': (120, 160, 'г/л'),
        'WBC': (4.0, 11.0, '10^9/л'),
        'RBC': (4.0, 6.0, '10^12/л'),
        'Platelets': (150, 400, '10^9/л')
    }

    # Кольори для статусів
    STATUS_COLORS = {
        'Healthy': '#28a745',
        'Warning': '#ffc107',
        'Moderate Risk': '#fd7e14',
        'Critical': '#dc3545'
    }


config = Config()