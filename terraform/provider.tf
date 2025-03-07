# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = "capable-sphinx-442212-k8"
  credentials = file("credentials.json")
  region = "europe-west1"
  zone = "europe-west1-b"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # This links Helm to Kubernetes
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Deploy Prometheus and Grafana using the Prometheus Community Chart
resource "helm_release" "prometheus" {
  name       = "prometheus-stack"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "69.4.1"  
  timeout = 2000

  create_namespace = true

}

resource "helm_release" "redis" {
  name       = "redis"
  chart      = "oci://registry-1.docker.io/bitnamicharts/redis"
  namespace  = "devops-webservice"
  version    = "18.19.2"

  set {
    name  = "auth.enabled"
    value = "false"  # simpler for now
  }

  set {
    name  = "master.containerPort"
    value = "6379"
  }

 # set {
  #  name  = "architecture"
   # value = "standalone"
  #}
}

#resource "helm_release" "grafana" {
#  name       = "grafana"
# namespace  = "monitoring"
#  repository = "https://grafana.github.io/helm-charts"
#  chart      = "grafana"
#  version    = "8.10.1" 
#  timeout = 2000

#  create_namespace = true

#}

# Deploy my web service via Helm using my local created Chart
resource "helm_release" "webservice" {
  name       = "webservice-chart"
  namespace  = "default"  
  chart      = "../webservice-chart"
  version    = "1.0.0"
}
