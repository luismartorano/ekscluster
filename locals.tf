locals {
  name         = "martorano-${replace(basename(path.cwd), "_", "-")}"
  region       = "us-east-1"
  cluster_name = "martorano-cluster"
  common_tags = {
    Vpc_Name = "${local.name}-${local.region}"
  }

  subnets = ["subnet-0f19cda42282c5d93", "subnet-0b59eaa2c2c86428b", "subnet-040f6ea90dff19be7", "subnet-04c1b7d7a8399de85", "subnet-036b98ebe5a696529", "subnet-052247e073f6732f4"]
}
