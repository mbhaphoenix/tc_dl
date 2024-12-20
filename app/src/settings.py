from pydantic_settings import BaseSettings
from functools import lru_cache

class Settings(BaseSettings):
    DB_HOST: str
    DB_USER: str
    DB_PASSWORD_SECRET_ID: str
    DB_CONNECTION_NAME: str
    DB_NAME: str
    DATA_BUCKET_NAME: str
    
    class Config:
        case_sensitive = True

@lru_cache()
def get_settings() -> Settings:
    return Settings() 