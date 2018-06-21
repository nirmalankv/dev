#aws provider variables
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}

#Network variables
variable "vpc_CIDR"{
default = "40.0.0.0/16"
}
variable "pub_sub_CIDR"{
default = "40.0.1.0/24"
}
variable "prv_sub_CIDR"{
default = "40.0.2.0/24"
}
variable "subnet_id"{
default = "subnet-651e6c3f"
}

#Ec2 variables
variable "keypair"{
default = "indu_keypair"
}
variable "instance_type"{
default = "t2.micro"
}
variable "ami_id"{
default = "ami-0835d74714565c95c"
}

#ASG variables
variable "min_size"{
default = "1"
}
variable "max_size"{
default = "5"
}
variable "desired"{
default = "2"
}

#Default variables
variable "count" {
 default = "2"
 }
variable "version"{
default = "3"
}
variable "env"{
default = "DEV"
}
variable "org"{
default = "HA"
}
