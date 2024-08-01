variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "aws_org_paths" {
  description = "AWS Organization Paths"
  type        = list(string)
}