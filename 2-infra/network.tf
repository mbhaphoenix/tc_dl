# Create VPC
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 10.0"

  project_id   = module.infra_project.project_id
  network_name = "vpc-${var.env_name}"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${local.layer}-private-subnet"
      subnet_ip             = "10.0.1.0/24"
      subnet_region         = local.common_config.default_region
      subnet_private_access = true
    },
  ]
}
