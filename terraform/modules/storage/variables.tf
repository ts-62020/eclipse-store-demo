
variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "account_tier" {
  default = "Standard"
  type    = string
}

variable "account_replication_type" {
  default = "LRS"
  type    = string
}

variable "allowed_headers" {
  default = ["*"]
  type    = list(string)
}

variable "allowed_methods" {
  default = ["GET", "HEAD", "OPTIONS"]
  type    = list(string)
}

variable "exposed_headers" {
  default = ["*"]
  type    = list(string)
}

variable "max_age_in_seconds" {
  default = 200
  type    = number
}

variable "allowed_origins" {
  default = ["*"]
  type    = list(string)
}

variable "container_access_type" {
  default = "blob"
  type    = string
}