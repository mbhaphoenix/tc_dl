from fastapi import FastAPI
from controllers import hello_controller, data_controller

app = FastAPI(
    title="TC_DL_2",
    docs_url="/docs",
    redoc_url="/redoc",
)

app.include_router(hello_controller.router, tags=["hello"])
app.include_router(data_controller.router, tags=["data"])