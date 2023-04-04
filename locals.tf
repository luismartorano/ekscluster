locals {
  name            = "${local.cluster_name}-${replace(basename(path.cwd), "_", "-")}"
  region          = "us-east-1"
  profile         = "martorano"
  cluster_version = "1.25"
  //worksparce -> Definir em terraform new workspace dev ou staging ou production
  dev        = terraform.workspace == "dev" ? "martorano-develop" : ""
  staging    = terraform.workspace == "staging" ? "martorano-staging" : ""
  production = terraform.workspace == "production" ? "martorano-production" : ""

  cluster_name = coalesce(local.dev, local.staging, local.production)
  common_tags = {
    Vpc_Name = "${local.name}-${local.region}"
  }

}
