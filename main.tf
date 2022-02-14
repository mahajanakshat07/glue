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



module "glue_crawler" {
  source = "./modules/glue_crawler"
  
}
module "glue_job" {
  source = "./modules/glue_job"
  
}
module "trigger" {
  source = "./modules/glue_trigger"
  job_name = module.glue_job.name_of_job

}


