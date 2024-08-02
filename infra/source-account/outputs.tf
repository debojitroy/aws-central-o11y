output "oam_link_arn" {
  value       = aws_oam_link.source_account_oam_link.arn
  description = "ARN of the OAM Link"
}

output "cw_central_monitoring_acc_role" {
  value       = aws_iam_role.central-monitoring-account-cw-role.arn
  description = "ARN of the CW Central Monitoring Account Role"
}