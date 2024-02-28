terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

variable "SECRET_KEY_BASE" {
  type = string
}

# resource "aws_ecr_repository" "lamb" {
#   name                 = "lamb"
#   image_tag_mutability = "MUTABLE"
#   force_delete         = true
#
#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lamb_role" {
  name               = "lamb_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "logs_permissions"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_lambda_function" "lamb" {
  package_type  = "Image"
  image_uri     = "919206211910.dkr.ecr.us-east-1.amazonaws.com/lamb:1"
  function_name = "lamb"
  role          = aws_iam_role.lamb_role.arn
  timeout       = 60

  environment {
    variables = {
      SECRET_KEY_BASE = var.SECRET_KEY_BASE
    }
  }
}
