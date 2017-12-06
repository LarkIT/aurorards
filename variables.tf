variable "rds_database_name" {
  description = "Database cluster name"
}

variable "environment_name" {
    description = "The name of the environment"
}

variable "vpc_id" {
  description = "The ID of the VPC that the RDS cluster will be created in"
}

variable "vpc_name" {
  description = "The name of the VPC that the RDS cluster will be created in"
}

variable "vpc_rds_subnet_ids" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "vpc_rds_security_group_ids" {
    description = "The IDs of the security groups that should be used for the RDS cluster instances"
}

variable "rds_master_username" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "rds_master_password" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "external_dns_enable" {
  default = true
}

variable "internal_domain_name" {
  default = ""
}

variable "external_domain_name" {
  default = ""
}