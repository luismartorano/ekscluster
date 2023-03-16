locals {
  name   = "${local.cluster_name}-${replace(basename(path.cwd), "_", "-")}"
  region = "us-east-1"
  //worksparce -> Definir em terraform new workspace dev ou staging ou production
  dev        = terraform.workspace == "dev" ? "martorano-develop" : ""
  staging    = terraform.workspace == "staging" ? "martorano-staging" : ""
  production = terraform.workspace == "production" ? "martorano-production" : ""

  cluster_name = coalesce(local.dev, local.staging, local.production)
  common_tags = {
    Vpc_Name = "${local.name}-${local.region}"
  }

  #subnets = ["subnet-0f19cda42282c5d93", "subnet-0b59eaa2c2c86428b", "subnet-040f6ea90dff19be7", "subnet-04c1b7d7a8399de85", "subnet-036b98ebe5a696529", "subnet-052247e073f6732f4"]
}
