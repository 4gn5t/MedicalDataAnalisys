from sqlalchemy import create_engine, Column, Integer, Float, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import datetime

Base = declarative_base()

class Prediction(Base):
    __tablename__ = 'predictions'

    id = Column(Integer, primary_key=True)
    patient_age = Column(Integer)
    patient_gender = Column(String)
    tsh_level = Column(Float)
    status = Column(String)
    risk_probability = Column(Float)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)