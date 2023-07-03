# Boilerplate

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}

resource "aws_organizations_account" "account" {
    name = "04 - Events and Messages"
    email = "wes.white+04eventsandmessages@hexthelight.co.uk"

    close_on_deletion = true

    tags = var.tags
}
