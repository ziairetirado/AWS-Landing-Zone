output "security_account_id" {
  value = aws_organizations_account.security.id
}

output "management_account_id" {
  value = var.management_account_id
}