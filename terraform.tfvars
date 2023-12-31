

public_subnets_WT = {
  web_tier_1 = {
    name              = "WEB_TIER_1",
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-west-2a"
  },
  web_tier_2 = {
    name              = "WEB_TIER_2",
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-west-2b"
  }
}

security_groups = {
  "Bastion_host_sg" : {
    description = "Security group for web servers"
    ingress_rules = [

      {
        description = "my_ssh"
        priority    = 202
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
  Web_tier_sg : {
    description = "Security group for web servers"
    ingress_rules = [
      {
        description = "ingress rule for http"
        priority    = 200
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "my_ssh"
        priority    = 202
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "ingress rule for http"
        priority    = 204
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
  App_tier_sg : {
    description = "Security group for web servers"
    ingress_rules = [
      {
        description = "ingress rule for http"
        priority    = 200
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}


Web_Tier_ec2 = {
  web_tier_1 = {
    Web_Tier_name = "WEB_TIER_1",
    subnet_id     = ""

  },
  web_tier_2 = {
    Web_Tier_name = "WEB_TIER_2",
    subnet_id     = ""
  }
}

App_Tier_ec2 = {
  app_tier_1 = {
    App_Tier_name = "APP_TIER_1",
    subnet_id     = ""

  },
  app_tier_2 = {
    App_Tier_name = "APP_TIER_2",
    subnet_id     = ""
  }
}




private_subnets_AT = {
  app_tier_1 = {
    name              = "APP_TIER_1",
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-west-2a"
  },
  app_tier_2 = {
    name              = "APP_TIER_2",
    cidr_block        = "10.0.5.0/24"
    availability_zone = "us-west-2b"
  }
}

private_subnets_db = {
  db_tier_1 = {
    name              = "DB_TIER_1"
    cidr_block        = "10.0.6.0/24"
    availability_zone = "us-west-2a"
  },
  db_tier_2 = {
    name              = "DB_TIER_2"
    cidr_block        = "10.0.7.0/24"
    availability_zone = "us-west-2b"
  }
}








