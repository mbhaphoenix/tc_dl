from functools import lru_cache

from google.cloud import secretmanager


class SecretManagerService:
    def __init__(self):
        self.client = secretmanager.SecretManagerServiceClient()
    
    def get_secret(self, secret_id: str) -> str:
        name = f"{secret_id}/versions/latest"
        response = self.client.access_secret_version(request={"name": name})
        return response.payload.data.decode("UTF-8")


@lru_cache()
def get_secret_manager() -> SecretManagerService:
    return SecretManagerService()
