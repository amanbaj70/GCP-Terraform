###############################
## GCP Linux VM - Variables  ##
## Maintainer - Aman Bajpai  ##
###############################

variable "linux_instance_type" {
  type        = string
  description = "VM instance type"
  default     = "e2-standard-2"
}
