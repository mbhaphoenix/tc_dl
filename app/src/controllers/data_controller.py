from fastapi import APIRouter

from services.data_service import DataService

router = APIRouter()
service = DataService()


@router.get("/data/{resource_name}")
async def get_data(resource_name: str):
    return {"data": service.get_data(resource_name)}
