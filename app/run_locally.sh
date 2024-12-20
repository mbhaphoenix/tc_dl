#!/bin/bash

# Load environment variables from .loacl file
export $(grep -v '^#' .local | xargs)
PYTHONPATH=src uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload