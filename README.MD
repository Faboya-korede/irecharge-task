# iRecharge DevOps Task 

## Objective

The goal of this Task was to create and deploy a simple API to Amazon Web Service (AWS) using  ECS Service with Infrastructure as Code (IaC) exclusively through Terraform. Additionally, GitHub Actions was implemented for Continuous Deployment (CD). The API returns the current time in JSON format via a GET request.

## Repository Structure

- `terraform/`: Contains all Terraform configurations for setting up AWS ECS Cluster 
- `node-project/`: Contains the source code for the API and Dockerfile.
- `.github/workflows/`: Contains GitHub Actions workflows for CI/CD.
- `README.md`: This file with setup and usage instructions.

## Prerequisites

Before running the setup, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://www.terraform.io/downloads)
- [AWS CLI](https://aws.amazon.com/cli/) (Command Line Interface)


## Setup Instructions


### 1. Configure AWS CLI

- **Create an IAM User:**
  1. Go to the AWS Management Console.
  2. Navigate to the IAM service.
  3. Click on "Users" and then "Add user."
  4. Provide a username and select "Programmatic access."
  5. Set permissions for the user (e.g., attach existing policies or create a new policy).
  6. Review and create the user. You will receive an Access Key ID and Secret Access Key.

- **Configure AWS CLI:**
  - Run the following command to configure your AWS CLI with your Access Key and Secret Key:

    ```bash
    aws configure
    ```

  You will be prompted to enter:
  - AWS Access Key ID
  - AWS Secret Access Key
  - Default region name
  - Default output format


### 2. Clone the Repository

```bash
git clone https://github.com/Faboya-korede/Shortlet-task.git
cd shortlet-task
```


### 3. Build and Push Docker Image

- Navigate to the `node-project` directory and build the Docker image:

```bash
cd node-project
docker build -t api .
```
- For Amazon ECR, first log in to your ECR repository

```bash
aws ecr get-login-password --region YOUR_REGION | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com
```

- Then tag and push the image

```bash
docker tag api:latest YOUR_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/api:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/api:latest
```

### 4. Initialize Terraform
- Navigate to the Terraform directory:

```bash
cd ../terraform
```

- Create cred.tfvars File

```bash
project_id       = "YOUR_PROJECT_ID"
region           = "YOUR_REGION"
cluster_location = "YOUR_CLUSTER_LOCATION" #us-eas1-b"
```

- Initialize Terraform

```bash
terraform init
```

### 5. Apply Terraform Configuration

- Apply the Terraform configuration to create the infrastructure and deploy the API:

```bash
terraform apply -var-file=cred.tfvars
```

### 6. Update DNS Record

### Get the External IP of the Load Balancer

1. **Go to the AWS Management Console:**

   - Navigate to `EC2 > Load Balancers`.

2. **Locate the Load Balancer associated with your service:**

   - Find the Load Balancer that corresponds to your service.

3. **Copy the external DNS name from the Load Balancer details:**

   - You will see an external DNS name in the Load Balancer details section. Copy this information.

### Update DNS Records

1. **Update your DNS provider's records:**

   - Log in to your DNS provider's management console.
   - Find the DNS records section and update the relevant CNAME record to point to the external DNS name you copied.
