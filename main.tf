terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "data-ingest-bucket"
    tags = {
      "Name" = "ny_taxi_bucket"
    }
  
}

#Creating a new VPC for our redshift cluster
resource "aws_vpc" "redshift_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "redshift_nytaxi"
  }
}

#Internet gateway for VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.redshift_vpc.id

  tags = {
    Name = "gateway"
  }
}

#Defining the default Security Group for our VPC

resource "aws_default_security_group" "redshift_security_group" {
  vpc_id     = aws_vpc.redshift_vpc.id
ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "redshift-sg"
  }
}

#Creating a couple of subnets for our cluster

resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.redshift_vpc.id
  cidr_block = "10.0.1.0/24"
tags = {
    name = "subnet_1"
  }
}


resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id]
tags = {
    environment = "dev"
    Name = "redshift-subnet-group"
  }
}


resource "aws_iam_role_policy" "s3_full_access_policy" {
  name = "redshift_s3_policy"
  role = aws_iam_role.redshift_role.id
policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "redshift_role" {
  name = "redshift_role"
assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
tags = {
    tag-key = "redshift-role"
  }
}

#Creating the Redshift Cluster
resource "aws_redshift_cluster" "default" {
  cluster_identifier = "samplecluster"
  database_name      = "samplecluster"
  master_username    = "sampleuser"
  master_password    = "Password123"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.id
  skip_final_snapshot = true
  iam_roles = aws_iam_role.redshift_role.managed_policy_arns
}
#Connecting to the Cluster
#Destroying the Cluster
