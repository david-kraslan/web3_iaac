variable "instance_name" {
  description = "Jumphost instance name"
  type        = string
  default     = "Jumphost"
  sensitive   = true
}

variable "instance_type" {
  description = "Jumphost instance type"
  type        = string
  default     = "t3.small"
}

variable "instance_ami_id" {
  description = "Jumphost instance AMI ID"
  type        = string
  default     = "ami-04cdc91e49cb06165"
}

variable "key_name" {
  description = "EC2 Keypair"
  type        = string
  default     = "devopskey"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "app" {
  description = "Name of the application"
  type        = string
  default     = "web3"
}

variable "settings_prometheus" {
  default = {
    alertmanager = {
      persistentVolume = {
        storageClassName = "gp2"
        size             = "10Gi"
        accessModes      = ["ReadWriteOnce"]
      }
    }
    server = {
      persistentVolume = {
        storageClassName = "gp2"
        size             = "10Gi"
        accessModes      = ["ReadWriteOnce"]
      }
    }
  }
  description = "Additional settings which will be passed to Prometheus Helm chart values."
}

variable "settings_grafana" {
  default = {
    persistence = {
      enabled          = true
      storageClassName = "gp2"
    }
    adminPassword = "admin"
  }
  description = "Additional settings which will be passed to Grafana Helm chart values."
}