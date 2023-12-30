#security groups for apptier{1,2}, webtier{1,2}, bastion host {1,2}
module "security-groups" {
  source  = "app.terraform.io/summercloud/security-groups/aws"
  version = "6.0.0"
  # insert required variables here
  # insert required variables here
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}

# Create Database Security Group
resource "aws_security_group" "database-sg" {
  name        = "Database SG"
  description = "Allow inbound traffic from application layer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.security-groups.security_group_id]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database SG"
  }
}