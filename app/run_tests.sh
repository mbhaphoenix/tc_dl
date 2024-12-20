#!/bin/bash

# Load environment variables from .loacl file
export $(grep -v '^#' .local | xargs)
PYTHONPATH=src pytest