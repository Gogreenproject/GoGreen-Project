resource "aws_db_instance" "gogreen_mysql_db" {
  db_name                = "mydb"
  engine                 = "mysql"
  identifier             = "myrdsinstance"
  allocated_storage      = 25
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = var.dbusername
  password               = random_password.db_password.result
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = aws_security_group.database-sg
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.id
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "$%&"
}
resource "aws_secretsmanager_secret" "gogreen_db" {
  name                    = "gogreen_db_instance1"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "gogreen_mysql_db" {
  secret_id = aws_secretsmanager_secret.gogreen_mysql_db.id
  secret_string = jsonencode({
    db_name  = "mydb"
    username = "dbadmin"
    password = random_password.db_password.result
    host     = aws_db_instance.gogreen_mysql_db.endpoint
  })
}

resource "aws_db_subnet_group" "database_subnet_group" {
  subnet_ids = [aws_subnet.private_subnets_db["db_tier_1"].id, aws_subnet.private_subnet["db_tier_2"].id]
}

