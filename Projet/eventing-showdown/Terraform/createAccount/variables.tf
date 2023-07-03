variable "tags" {
  description = "Default tags"
  type        = map(string)
  default = {
    project   = "004-Events_and_Messages"
    temporary = "true"
  }
}