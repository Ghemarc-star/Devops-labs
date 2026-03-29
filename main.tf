terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}

# This resource won’t actually be created because we won’t run "terraform apply"
resource "aws_instance" "web" {
  count         = var.node_count
  ami           = "ami-0c55b159cbfafe1f0"   # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"

  tags = {
    Name = "web-${count.index}"
  }
}