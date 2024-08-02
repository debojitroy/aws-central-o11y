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

# Create the link in Source Account -> Central Monitoring Account
resource "aws_oam_link" "source_account_oam_link" {
  label_template  = "$AccountName"
  resource_types  = ["AWS::CloudWatch::Metric", "AWS::Logs::LogGroup", "AWS::XRay::Trace", "AWS::ApplicationInsights::Application", "AWS::InternetMonitor::Monitor"]
  sink_identifier = var.central_sink_identifier
}

# Create the role in Source Account to Allow Central Monitoring Account to share data
resource "aws_iam_role" "central-monitoring-account-cw-role" {
  name = "CloudWatch-CrossAccountSharingRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : var.monitoring_account_id
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Define the Managed Policies for the Role
# CW ReadOnly Access
data "aws_iam_policy" "cw-ro-access" {
  name = "CloudWatchReadOnlyAccess"
}

# CW Automatic Dashboard Access
data "aws_iam_policy" "cw-dash-access" {
  name = "CloudWatchAutomaticDashboardsAccess"
}

# Xray ReadOnly Access
data "aws_iam_policy" "xray-ro-access" {
  name = "AWSXrayReadOnlyAccess"
}

# Attach the policies to the role
resource "aws_iam_role_policy_attachment" "central-monitoring-account-cw-role-cw-ro-access" {
  role       = aws_iam_role.central-monitoring-account-cw-role.name
  policy_arn = data.aws_iam_policy.cw-ro-access.arn
}

resource "aws_iam_role_policy_attachment" "central-monitoring-account-cw-role-cw-dash-access" {
  role       = aws_iam_role.central-monitoring-account-cw-role.name
  policy_arn = data.aws_iam_policy.cw-dash-access.arn
}

resource "aws_iam_role_policy_attachment" "central-monitoring-account-cw-role-xray-ro-access" {
  role       = aws_iam_role.central-monitoring-account-cw-role.name
  policy_arn = data.aws_iam_policy.xray-ro-access.arn
}

