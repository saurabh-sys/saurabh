variable "availability_zone" {
  type = "list"
}
variable "public_subnet_cidr" {
  type = "list"
}
variable "private_subnet_cidr" {
  type = "list"
}

variable "cidr" {
  default = "0.0.0.0/0"
}

variable "in_prots" {
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "out_ports" {
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

