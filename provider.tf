terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }

  required_version = ">= 1.3.7"
}

# Configuration will need to be adjusted for your specific connection to AWS
provider "aws" {
  shared_config_files      = ["C:\\Users\\xxxxx\\.aws\\config)"]
  shared_credentials_files = ["C:\\Users\\xxxxx\\.aws\\credentials)"]
  alias  = "default"
  default_tags {
    tags = local.tags
  }
}

# Very Important: Configuration of tags to be added to the provisioned resources. In this way
# we can then identify the provisioned resources using AWS Resource Groups & Tag Editor.