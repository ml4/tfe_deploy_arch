terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # configuration_aliases = [aws.secondary, aws.tertiary]
      version = ">= 4.0.0"
    }
  }

  cloud {
    organization = "ml4"
    workspaces {
      name = "c-dev-net-lab"
    }
  }
}

provider "aws" {
  region = var.primary_region
  default_tags {
    tags = {
      Environment = var.common_tags.Env
      Owner       = var.common_tags.Owner
      Project     = var.common_tags.Project
    }
  }
}

# provider "aws" {
#   alias  = "secondary"
#   region = var.secondary_region
#   default_tags {
#     tags = {
#       Environment = var.common_tags.Env
#       Owner       = var.common_tags.Owner
#       Project     = var.common_tags.Project
#     }
#   }
# }

# provider "aws" {
#   alias  = "tertiary"
#   region = var.tertiary_region
#   default_tags {
#     tags = {
#       Environment = var.common_tags.Env
#       Owner       = var.common_tags.Owner
#       Project     = var.common_tags.Project
#     }
#   }
# }

# provider "aws" {
#   alias  = "quaternary"
#   region = var.quaternary_region
#   default_tags {
#     tags = {
#       Environment = var.common_tags.Env
#       Owner       = var.common_tags.Owner
#       Project     = var.common_tags.Project
#     }
#   }
# }

# provider "aws" {
#   alias  = "quinary"
#   region = var.quinary_region
#   default_tags {
#     tags = {
#       Environment = var.common_tags.Env
#       Owner       = var.common_tags.Owner
#       Project     = var.common_tags.Project
#     }
#   }
# }

# provider "aws" {
#   alias  = "senary"
#   region = var.senary_region
#   default_tags {
#     tags = {
#       Environment = var.common_tags.Env
#       Owner       = var.common_tags.Owner
#       Project     = var.common_tags.Project
#     }
#   }
# }
