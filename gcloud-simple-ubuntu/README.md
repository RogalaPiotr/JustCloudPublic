# gcloud-simple-ubuntu

Simple deployment virtual machine with Linux Ubuntu 16.04 system in Google Cloud Platform. During deployment is creating a machine in default network with external IP. The important thing to run this deployment is to replace "your-project-name" to your name project in GCP before running.

## Command to deployment
```json
gcloud deployment-manager deployments create simple-ubuntu --config vm.yaml
```

## Author
Piotr Rogala
http://justcloud.pl