import requests
import pandas as pd
from typing import Dict, List
from config import config


class BackendAPIClient:
    def __init__(self):
        self.base_url = config.BACKEND_API_URL
        self.api_key = config.API_KEY
        self.headers = {
            'Content-Type': 'application/json',
            'X-API-Key': self.api_key
        }

    def health_check(self) -> Dict:
        """Перевірка доступності backend"""
        try:
            response = requests.get(f"{self.base_url}/health", timeout=5)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            return {"status": "error", "message": str(e)}

    def predict_single(self, patient_data: Dict) -> Dict:
        """Прогнозування для одного пацієнта"""
        try:
            response = requests.post(
                f"{self.base_url}/api/v1/predict",
                json=patient_data,
                headers=self.headers,
                timeout=10
            )
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            return {"error": str(e)}

    def predict_batch(self, patients_df: pd.DataFrame) -> List[Dict]:
        """Прогнозування для багатьох пацієнтів"""
        results = []
        for _, row in patients_df.iterrows():
            patient_data = row.to_dict()
            result = self.predict_single(patient_data)
            results.append(result)
        return results


api_client = BackendAPIClient()