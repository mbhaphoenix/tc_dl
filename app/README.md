# App Directory

This directory contains the fast_api application code.

It expose 2 endpoints :
- `/hello` returns hello_world
- `/data/{resource_name}` will fetch from gs://<data-bucket>/data/{resource_name}.csv and insert or replace it in cloud SQL DB. read the table and return the resutl as http json response.
- `/docs` for api documentation

## Structure

- **src**: Contains the source code for the FastAPI application, including controllers and services.
- **requirements.txt**: Lists the Python dependencies required for the application.
- **Dockerfile**: Defines the Docker image for the application.
- **cloudbuild.yaml**: Configuration for Google Cloud Build to automate the build and deployment process.
- **tests**: Contains test cases for the application.

## Running Locally

To run the application locally, use the following commands:
```bash
bash
cd app
./run_locally.sh
```

to run the tests locally, use:
```bash
bash
cd app
./run_tests.sh
```
