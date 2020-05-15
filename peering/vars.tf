variable "avail_zone" {
  default = "us-east-1a"
}

variable "A_Z" {
  default = "us-east-1b"
}

variable "subnet_A" {
  default = "20.0.1.0/24"
}
variable "Private_A" {
  default = "20.0.2.0/24"
}

variable "publicsubnet" {
  default = "10.0.1.0/24"
}
variable "PrivateSubnet" {
  default = "10.0.2.0/24"
}


variable "cidr" {
  default = "0.0.0.0/0"
}

variable "in_ports" {
    type = list(map(string))

default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

variable "out_ports" {
    type = list(map(string))
 
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

