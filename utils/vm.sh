#!/bin/bash

# Configuration
PROJECT_ID="prj-infra-dev-f265"
ZONE="europe-west1-b"
INSTANCE_NAME="vm-dev"
LOCAL_PORT=8080
REMOTE_PORT=8080

# Function to start the VM
start_vm() {
  echo "Starting VM $INSTANCE_NAME..."
  gcloud compute instances start $INSTANCE_NAME --project=$PROJECT_ID --zone=$ZONE
}

# Function to stop the VM
stop_vm() {
  echo "Stopping VM $INSTANCE_NAME..."
  gcloud compute instances stop $INSTANCE_NAME --project=$PROJECT_ID --zone=$ZONE
}

# Function to check the status of the VM
status_vm() {
  echo "Checking status of VM $INSTANCE_NAME..."
  gcloud compute instances describe $INSTANCE_NAME --project=$PROJECT_ID --zone=$ZONE --format='get(status)'
}

# Function to set up port forwarding
port_forward() {
  echo "Setting up port forwarding from localhost:$LOCAL_PORT to $INSTANCE_NAME:$REMOTE_PORT..."
  gcloud compute ssh $INSTANCE_NAME --project=$PROJECT_ID --zone=$ZONE -- -NL $LOCAL_PORT:localhost:$REMOTE_PORT
}

# Function to run a command on the VM
run_command() {
  if [ -z "$2" ]; then
    echo "Error: No command provided to run on the VM."
    exit 1
  fi

  echo "Running command on VM $INSTANCE_NAME: $2"
  gcloud compute ssh $INSTANCE_NAME --project=$PROJECT_ID --zone=$ZONE -- "$2"
}

# Main menu
case $1 in
  start)
    start_vm
    ;;
  stop)
    stop_vm
    ;;
  status)
    status_vm
    ;;
  forward)
    port_forward
    ;;
  run)
    run_command "$@" # example: run "sudo docker ps"

    ;;
  *)
    echo "Usage: $0 {start|stop|status|forward|run <command>}"
    exit 1
    ;;
esac