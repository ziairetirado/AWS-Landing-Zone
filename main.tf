resource "aws_organizations_account" "security" {
  name  = "security-account"
  email = "ztsecurity@gmail.com"

  role_name = "OrganizationAccountAccessRole"
}

resource "aws_organizations_account" "dev" {
  name  = "dev-account"
  email = "ztdev@gmail.com"

  role_name = "OrganizationAccountAccessRole"
}

resource "aws_organizations_account" "prod" {
  name  = "prod-account"
  email = "ztprod@gmail.com"

  role_name = "OrganizationAccountAccessRole"
}
