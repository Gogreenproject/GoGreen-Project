
# Users
resource "aws_iam_user" "SysAdmin" {
  for_each = toset(["sysadmin1", "sysadmin2"])
  name     = each.key
}
resource "aws_iam_user" "DBAdmin" {
  for_each = toset(["dbadmin1", "dbadmin2"])
  name     = each.key
}
resource "aws_iam_user" "Monitoring" {
  for_each = toset(["monitoruser1", "monitoruser2", "monitoruser3", "monitoruser4"])
  name     = each.key
}

# Groups
resource "aws_iam_group" "sysadmin_group" {
  name = "Sytem_Administrator_Group"
}
resource "aws_iam_group" "dbadmin_group" {
  name = "Database_Administrator_Group"
}
resource "aws_iam_group" "Monitoring_Group" {
  name = "Monitoring_Group"
}



resource "aws_iam_group_membership" "team1" {
  name     = "sysadmin_group-membership"
  for_each = toset(["sysadmin1", "sysadmin2"])
  users    = [aws_iam_user.SysAdmin[each.key].name]
  group    = aws_iam_group.sysadmin_group.name
}

resource "aws_iam_group_membership" "team2" {
  name     = "dbadmin_group-membership"
  for_each = toset(["dbadmin1", "dbadmin2"])
  users    = [aws_iam_user.DBAdmin[each.key].name]
  group    = aws_iam_group.dbadmin_group.name
}

resource "aws_iam_group_membership" "team3" {
  name     = "monitoring_group-membership"
  for_each = toset(["monitoruser1", "monitoruser2", "monitoruser3", "monitoruser4"])
  users    = [aws_iam_user.Monitoring[each.key].name]
  group    = aws_iam_group.Monitoring_Group.name
}
############################################
# Group Policy
resource "aws_iam_group_policy" "sysadmin_policy" {
  name  = "sysadmin_policy"
  group = aws_iam_group.sysadmin_group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group_policy" "dbadmin_policy" {
  name  = "dbadmin_policy"
  group = aws_iam_group.dbadmin_group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group_policy" "monitoring_policy" {
  name  = "monitoring_policy"
  group = aws_iam_group.Monitoring_Group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
