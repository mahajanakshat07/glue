terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
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
glue_version = "3.0"
  worker_type = "G.1X"
  number_of_workers = "10"

  
  

  

  command {
    script_location = "s3://fifadataforetl/code.py"
    python_version = "3"
  }
  


}



    resource "aws_glue_crawler" "democrawler" {
  database_name = aws_glue_catalog_database.data.name
  name          = "democrawler"
  role          =  "arn:aws:iam::186972323852:role/service-role/AWSGlueServiceRole-Etl"
  

  
  s3_target {
    path = "s3://fifadataforetl/terraform/data.csv"
  }

}

  
