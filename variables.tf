variable "prefix" {
  type    = string
  default = "Gogreen"
}

variable "public_subnets" {
  type = map(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))

  default = {
  }
}

variable "ec2_instance" {
  type = map(object({
    name      = string,
    subnet_id = string
  }))
  default = {
  }
}

#  variable "vpc_cidr" {
#     type = string
#  }

variable "security_groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })))
    egress_rules = list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "Web_Tier_ec2" {
  type = map(object({
    Web_Tier_name = string,
    subnet_id     = string
  }))
  default = {
  }
}

variable "App_Tier_ec2" {
  type = map(object({
    App_Tier_name = string,
    subnet_id     = string
  }))
  default = {
  }
}

variable "public_subnets_WT" {
  type = map(object({
    name              = string,
    cidr_block        = string,
    availability_zone = string
  }))

  default = {
  }
}


variable "private_subnets_AT" {
  type = map(object({
    name              = string,
    cidr_block        = string,
    availability_zone = string
  }))

  default = {
  }
}



# variable "rds_storage" {
#   description = "RDS storage space"
#   default     = "10"
# }

# variable "rds_engine" {
#   description = "RDS engine type"
#   default     = "mysql"
# }

# variable "rds_instance_class" {
#   description = "RDS instance class"
#   default     = "db.t2.micro"
# }

# variable "rds_name" {
#   description = "Name of the RDS"
#   default     = "mysql_rds"
# }

# variable "rds_username" {
#   description = "Username of the RDS"
#   default     = "mysql_terraform"
# }

# variable "rds_password" {
#   description = "Password of the RDS"
#   default     = "terraformrds"
# }

# variable "rds_subnet_name" {
#   description = "Name of the RDS subnet group"
#   default     = "rds_group"
# }

# variable "private_subnets_db" {
#   type = map(object({
#     name              = string,
#     cidr_block        = string,
#     availability_zone = string
#   }))

#   default = {
#   }
# }