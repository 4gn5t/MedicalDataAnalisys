import random
from typing import Dict, List, Tuple


class MockMLService:
    # Нормальні діапазони показників
    NORMAL_RANGES = {
        'tsh_level': (0.4, 4.0),
        't3_level': (1.3, 3.1),
        't4_level': (5.0, 12.0),
        'insulin': (2.6, 24.9),
        'hemoglobin': (120, 160),
        'wbc': (4.0, 11.0),
        'rbc': (4.0, 6.0),
        'platelets': (150, 400)
    }

    def predict_health_status(self, data: dict) -> dict:
        anomalies = self._detect_anomalies(data)
        risk_score = self._calculate_risk_score(data, anomalies)
        status, recommendation = self._determine_status(risk_score, anomalies)
        confidence = self._calculate_confidence(data)

        return {
            "status": status,
            "risk_probability": round(risk_score * 100, 2),
            "recommendation": recommendation,
            "anomalies": anomalies,
            "confidence": round(confidence * 100, 2)
        }

    def _detect_anomalies(self, data: dict) -> List[str]:
        anomalies = []

        for key, (min_val, max_val) in self.NORMAL_RANGES.items():
            value = data.get(key)
            if value is None:
                continue

            if value < min_val:
                anomalies.append(f"Low {key.upper()}: {value}")
            elif value > max_val:
                anomalies.append(f"High {key.upper()}: {value}")

        return anomalies

    def _calculate_risk_score(self, data: dict, anomalies: List[str]) -> float:
        base_risk = len(anomalies) * 0.15

        # Додатковий ризик для критичних показників
        if data.get('tsh_level', 0) > 10 or data.get('tsh_level', 0) < 0.1:
            base_risk += 0.3

        # Вікова корекція
        age = data.get('age', 30)
        if age > 60:
            base_risk += 0.1

        # Додаємо випадковість для реалістичності
        noise = random.uniform(-0.05, 0.05)

        return min(1.0, max(0.0, base_risk + noise))

    def _determine_status(self, risk_score: float, anomalies: List[str]) -> Tuple[str, str]:
        if risk_score < 0.3 and len(anomalies) == 0:
            return "Healthy", "Усі показники в нормі. Продовжуйте дотримуватися здорового способу життя."
        elif risk_score < 0.5:
            return "Warning", "Виявлено незначні відхилення. Рекомендовано консультація ендокринолога."
        elif risk_score < 0.7:
            return "Moderate Risk", "Виявлено помірні відхилення. Необхідне додаткове обстеження."
        else:
            return "Critical", "Виявлено критичні відхилення! Терміново зверніться до лікаря!"

    def _calculate_confidence(self, data: dict) -> float:
        # Впевненість залежить від кількості наданих даних
        total_fields = len(self.NORMAL_RANGES)
        provided_fields = sum(1 for key in self.NORMAL_RANGES if data.get(key) is not None)

        return (provided_fields / total_fields) * random.uniform(0.85, 0.95)


ml_service = MockMLService()


def predict_health_status(data: dict) -> dict:
    return ml_service.predict_health_status(data)
