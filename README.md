# Questions answers
## Cost Optimization ?
Rather than using Compute Engine VM and Cloud SQL which are running and consuming resources continuasly, we can use 
- Cloud Run to host the application and only will cost as only the time it is running. When there are no requests Cloud Run can scale to 0.
- Firestore can be use as replacement for Cloud SQL. It will cost less because it will charge only based on the data size stored and number of reads and write. So for small application, defentily it will cost less

## Managing multiple environments
Through terraform workspaces and tfvars (terraform varaiables) proper to that environment in 2-infra folder. I already created a dev environment. 
Under 1-cicd I created terraform triggers to manage the dev environment.

# Test Case Doctolib (TC_DL)

The architecture diagram (`tc_dl_architecture.png`) below is good picture of the Google Cloud Components that have been deployed in `dev` environment.

[Architecture diagram](tc_dl_architecture.png)

## Overview

This repository contains the TC_DL application and its required infrastructure as code using terraform. , which is structured to facilitate efficient development and deployment. The architecture diagram above provides a visual representation of the application's components and their interactions.

## Folder Structure
The struture is inspired from Cloud Foundation Toolkit (CFT) best practices

**_For further details please check the `README.md` under each folder._**

- **1-cicd**: Must be deployed first manually. Contains infrastructure as code for CI/CD pipelines and artifacts registry for managing dockers repositories
- **2-infra**: Must be deployed second through CICD pipline. Contains infrastructure as code for the diffrent Google Cloud components and to deploy the application.
- **app**: Must be deployed last through CICD pipline. Contains the application code, including the FastAPI application.

