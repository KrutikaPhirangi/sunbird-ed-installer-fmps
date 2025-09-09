This guide walks you through installing **Obsrv** in FMPS using the `obsrv-automation` repository. The setup includes configuring infrastructure with Terraform/Terragrunt and deploying services with Helm.

---

## Prerequisites

- Google Cloud CLI [`gcloud`](https://cloud.google.com/sdk/docs/install#deb) installed and authenticated
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) must be installed.
- Access to the [obsrv-automation](https://github.com/Sanketika-Obsrv/obsrv-automation) GitHub repository.
- Ensure your Google Cloud account has the following permissions:

    ```
    GCS: Create and manage Cloud Storage buckets for storing Terraform state.
    GKE: Create and manage Kubernetes clusters for deploying Obsrv.
    IAM: Create and assign IAM roles and service accounts for resource access control```

## Installation Steps

### 1. Clone the Repository

```
git clone https://github.com/Sanketika-Obsrv/obsrv-automation.git
git checkout 1.9.2-fmps1
cd obsrv-automation/terraform/gcp
```
## Edit Cluster Configuration

Edit the file `vars/cluster_overrides.tfvars` with your environment-specific settings:

```
project                                 = "<myproject_id>"
building_block                          = "obsrv"
env                                     = "dev"
region                                  = "us-central1"
gke_cluster_location                    = "us-central1"
zone                                    = "us-central1-a"
timezone                                = "UTC"
```
ℹ️ `Note`: Update the env, region, zone with the existing cluster details.

## Configure GCS Bucket

Obsrv uses a **GCS bucket** to store Terraform state.

Create or edit the `obsrv.conf` file in `infra-setup` with the following:

```
GOOGLE_PROJECT_ID= obsrv-123
GOOGLE_TERRAFORM_BACKEND_BUCKET=obsrv-cluster-tfstate
GOOGLE_TERRAFORM_BACKEND_BUCKET_REGION=us-central1
```
ℹ️ `Note`: The bucket will be automatically created during installation if it doesn't exist.

## 🔧 Run the Installation Script

 Execute the following command:

    ```
    time ./obsrv.sh install --provider gcp --config ./obsrv.conf
    ```
## Update Global Cloud Configurations
Edit the file `global-cloud-values-gcp.yaml` and ensure following values are correctly set.

```yaml
global:
  project_id: 
  cloud_storage_region:  
  cloud_storage_config: 
  postgresql_backup_cloud_bucket: 
  checkpoint_bucket: 
  velero_backup_cloud_bucket: 

service_accounts:
  config-api: 
  dataset-api: 
  druid-raw: 
  flink-sa: 
  postgres: 
  secor: 
  spark: 
  velero: 
```

Note: Value for cloud_storage_config you will get in `terraform/gcp/credentials/*.json`

## Install Core Services

Navigate to the Helm charts directory and install the core services:

```
cd ../../helmcharts/kitchen
export cloud_env=gcp
bash install.sh core-setup
```

## Configure Domain Mapping

After installation of core services:

1. Get the external IP of the **Kong LoadBalancer service**.

2. Update the `global-values.yaml` file with the following:

```
domain: "<external_ip>.sslip.io"
```

## Install All Services

```
 bash install.sh all
```
## Completion

Once the script execution completes:

- Access the Obsrv UI at:

``
https://<external_ip>.sslip.io/console
``

- Confirm that all services are running and accessible in your GKE cluster.
