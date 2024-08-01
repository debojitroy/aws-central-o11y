terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }

  required_version = ">= 1.9.3"
}

provider "aws" {
  region = var.region
}

resource "aws_oam_sink" "central_monitoring_account_oam_sink" {
  name = "CentralSink"
}

resource "aws_oam_sink_policy" "central_monitoring_account_oam_sink_policy" {
  sink_identifier = aws_oam_sink.central_monitoring_account_oam_sink.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : ["oam:CreateLink", "oam:UpdateLink"],
        "Effect" : "Allow",
        "Resource" : "*",
        "Principal" : "*",
        "Condition" : {
          "ForAnyValue:StringLike" : {
            "aws:PrincipalOrgPaths" : var.aws_org_paths
          }
        }
      }
    ]
  })
}