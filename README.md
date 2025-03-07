# DevOps Infrastructure with Terraform, Helm, and Kubernetes

## 📌 Project Overview  
This project sets up a **Kubernetes-based infrastructure** using **Terraform** and **Helm** to deploy a web service with **Redis** for persistent state and **Prometheus-Grafana** for monitoring.

## 🏗️ Architecture  
```plaintext
                +------------------------+
                |    Web Service (Go)     |
                |    - REST API           |
                |    - Uses Redis Cache   |
                +------------------------+
                          |
                          v
                +------------------------+
                |        Redis           |
                |  - Caching Layer       |
                +------------------------+
                          |
                          v
                +------------------------+
                |    GKE Cluster         |
                |  - Managed by Terraform |
                +------------------------+
                          |
                          v
                +------------------------+
                | Monitoring Stack       |
                | - Prometheus           |
                | - Grafana Dashboard    |
                +------------------------+
```


## 🚀 Tech Stack  
- **Cloud:** Google Kubernetes Engine (GKE)  
- **Infrastructure as Code:** Terraform  
- **Container Orchestration:** Kubernetes (Managed by GCloud)  
- **Configuration Management:** Helm  
- **Monitoring:** Prometheus & Grafana  
- **Database:** Redis  
- **Application:** Go  

## 🔧 Setup & Deployment  

### 1️⃣ Prerequisites  
- Install **Terraform**, **kubectl**, **gcloud-cli** and **Helm**  
- Authenticate to **Google Cloud**:  
  ```sh
  gcloud auth application-default login
  ```
- Download the credentials.json from the Project from Browser or use this command :
  ```sh
  gcloud iam service-accounts keys create credentials.json \
  --iam-account=<your-service-account>@<your-project-id>.iam.gserviceaccount.com

  ```
  then place the file in the /terraform folder of the cloned project

### 2️⃣ Infrastructure Setup  

#### Clone Repository  
First, clone this repository and navigate into it:  

```sh
git clone <repo-url>
cd <repo-name>
```

#### Initialize Terraform

Ensure Terraform is installed, then run:
```sh
terraform init
terraform apply -auto-approve
```
This will: ✅ Create the GKE cluster . The other services will fail at first as the cluster is not running and the services can't be deployed directly
- **Important**: The first time you run `terraform apply`, it will create the GKE cluster, but it will **fail to deploy the services** (Web service, Redis, and Prometheus-Grafana) because the cluster is not yet fully running. This is expected and will be fixed in the next step.


#### Get Kubernetes Credentials
Once the infrastructure is up, connect to the kubernetes cluster:

```sh
gcloud container clusters get-credentials primary --zone europe-west1-b --project capable-sphinx-442212-k8
```

### 3️⃣ Deploy Services 
Next apply terraform again so the services like **Redis**, **Prometheus-Grafana** and the **Webservice** can be deployed on the container

```sh
terraform apply -auto-approve
```
This will:
- ✅ Deploy our Webservice
- ✅ Deploy Redis using Helm
- ✅ Deploy the Prometheus-Grafana stack using Helm

### :four: Verify Deployment
#### Check Running Pods
Run the following command to see the status of your pods:

```sh
kubectl get pods -A
```
#### Check Services
To check the services:

```sh
kubectl get svc -n devops-webservice
```
Here, you should see the **webservice** and **Redis** instances listed as running.

### 5️⃣ Mapping Cluster IP to a Local Domain  

Since the application is not running on a **public DNS**, we need to manually map the domain to the **Cluster IP** in the `/etc/hosts` file to enable proper communication from the local machine.  

#### 1️ Get the Cluster IP  
Run the following command to find the **Cluster IP** of your web service:  
```sh
kubectl get svc -n devops-webservice
```
#### 2️ Edit the /etc/hosts File
open the file using a text editor
```sh
sudo nano etc/hosts/
```
and then add this entry
```sh
<Cluster-IP>  devops-webservice.de
```

 Now, you can access the application under `http://devops-webservice.de:8080`


## 📊 Monitoring & Logging
Prometheus collects application metrics.

Grafana visualizes data with dashboards.

To Access the prometheus UI under http://localhost:9090/ 
port-forward to your local machine
```sh
kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-prometheus 9090
```

To Access grafana dashboards under http://localhost:3000/
port forward port-forward to your local machine
```sh
kubectl port-forward -n monitoring svc/prometheus-stack-grafana 3000:80
```


## 🔄 **Upgrading Services**

To upgrade the services (e.g., webservice, Redis, Prometheus-Grafana), follow these steps:

1. **Update the Service Configuration**  
   Modify the configuration files, values, or Helm charts as needed. For the web service, make sure to update the chart in your repo with any new changes.

2. **Upgrade the Services with Terraform (Using `helm_release`)**  
   Re-run the `terraform apply` command to apply changes to all services managed by Terraform:
   ```bash
   terraform apply -auto-approve
    ```
4. **Upgrade the Webservice with helm**
   
   When modifying the webservice in the helm-chart, apply the changes for the chart via helm directly:
   ```bash
    helm upgrade webservice-chart ./webservice-chart --namespace default
   ```


## 🚀 Future Improvements

- Set up a CI/CD pipeline to automate infrastructure deployment and application updates.
- Automate DNS mapping to avoid manual /etc/hosts updates by integrating a managed DNS service with the Ingress controller.

