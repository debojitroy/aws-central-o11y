variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "monitoring_account_id" {
  description = "Central Monitoring Account Id"
  type        = string
}

variable "central_sink_identifier" {
  description = "Central Sink Identifier"
  type        = string
}