import joblib
import numpy as np
from pathlib import Path


class MLService:
    def __init__(self):
        models_dir = Path(__file__).parent.parent.parent / "models"
        self.thyroid_model = joblib.load(models_dir / "thyroid_classifier.pkl")
        self.anomaly_detector = joblib.load(models_dir / "anomaly_detector.pkl")
        self.scaler = joblib.load(models_dir / "scaler.pkl")

    def predict(self, data: dict) -> dict:
        features = self._prepare_features(data)

        thyroid_pred = self.thyroid_model.predict_proba(features)[0]
        is_anomaly = self.anomaly_detector.predict(features)[0]

        return {
            "status": self._determine_status(thyroid_pred, is_anomaly),
            "risk_probability": float(max(thyroid_pred) * 100),
            "confidence": float(np.max(thyroid_pred) * 100),
            "anomalies": self._detect_anomalies(data)
        }
