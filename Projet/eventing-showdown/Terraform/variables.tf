variable "tags" {
  description = "Default tags"
  type        = map(string)
  default = {
    project   = "004-Events_and_Messages"
    temporary = "true"
  }
}

variable"account_id" {
  description = "account id"
  type = string
  default = "140033975826"
}