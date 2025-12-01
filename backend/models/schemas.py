from pydantic import BaseModel, Field, validator
from typing import Optional


class PatientData(BaseModel):
    age: int = Field(..., gt=0, le=120)
    gender: str = Field(..., pattern="^(Male|Female)$")

    # Гормони щитовидної залози
    tsh_level: float = Field(..., ge=0, le=100, description="Thyroid Stimulating Hormone")
    t3_level: float = Field(..., ge=0, le=10)
    t4_level: float = Field(..., ge=0, le=25)

    # Інші гормони
    insulin: float = Field(..., ge=0, le=300)
    cortisol: Optional[float] = Field(None, ge=0, le=1000)
    testosterone: Optional[float] = Field(None, ge=0, le=50)
    estrogen: Optional[float] = Field(None, ge=0, le=500)

    # Загальний аналіз крові
    hemoglobin: Optional[float] = Field(None, ge=0, le=200)
    wbc: Optional[float] = Field(None, ge=0, le=50)
    rbc: Optional[float] = Field(None, ge=0, le=10)
    platelets: Optional[float] = Field(None, ge=0, le=1000)

    @validator('gender')
    def validate_gender(cls, v):
        if v not in ['Male', 'Female']:
            raise ValueError('Gender must be Male or Female')
        return v


class PredictionResponse(BaseModel):
    status: str
    risk_probability: float
    recommendation: str
    anomalies: list[str]
    confidence: float
