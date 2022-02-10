terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIASXCDLIAGM7VSTN3C"
  secret_key = "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"
}


resource "aws_glue_catalog_database" "data" {
    name = "mydatabase"
  
}
resource "aws_iam_role" "my-role" {
 name = "my-role"

 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "my-policy" {
 name = "my-policy"
 role = aws_iam_role.my-role.id
 policy = "${file("hello.json")}"


 # This policy is exclusively available by my-role.
}

resource "aws_glue_job" "example" {
  name     = "example"
  role_arn = "arn:aws:iam::186972323852:role/service-role/AWSGlueServiceRole-Etl"

  command {
    script_location = "s3://fifadataforetl/code.py"
  }
}



    resource "aws_glue_crawler" "example" {
  database_name = aws_glue_catalog_database.data.name
  name          = "example"
  role          =  "arn:aws:iam::186972323852:role/service-role/AWSGlueServiceRole-Etl"
  
  s3_target {
    path = "s3://fifadataforetl/terraform/data.csv"
  }

  provisioner "local-exec" {
    command = "aws glue start-crawler --name example"
  }
}

  
