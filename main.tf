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




resource "aws_glue_job" "version1" {
  name     = "version1"
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
  schedule = "cron(*/5 * * * ? *)"
  type     = "SCHEDULED"


  
  s3_target {
    path = "s3://fifadataforetl/terraform/data.csv"
  }

}

  resource "aws_glue_trigger" "trigger2" {
  name     = "example"
  schedule = "cron(*/5 * * * ? *)"
  type     = "SCHEDULED"

  actions {
    job_name = aws_glue_job.version1.name
  }
}
