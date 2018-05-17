variable "region" {
  description = "AWS region"
  default     = "us-east-2"
}

variable "group" {
  description = "Group name"
  default     = "super_developer"
}

variable "users" {
  description = "List of users"
  type        = "list"
  default     = ["test.user1", "test.user2"]
}
