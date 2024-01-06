variable "prefix" {
  type    = string
  default = "Gogreen"
}





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


