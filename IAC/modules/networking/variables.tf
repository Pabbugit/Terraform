variable "vpc_cidr" {
  default = "10.0.0.0/16"

}

variable "pub_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "env_prefix" {
  default = "dev"
}