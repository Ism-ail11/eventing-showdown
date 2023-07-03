output "account_id" {
    description = "account ID of new account"
    value = aws_organizations_account.account.id
}