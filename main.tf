module "eks" {
  source = "./module-eks"

  region                 = var.aws_region
  author                 = "skyglass"
  cluster_name           = var.cluster_name
}

module "app" {
  source                                           = "./module-app"

  region                                           = var.aws_region
  environment                                      = var.environment
  domain_name                                      = "greeta.net"
  cluster_id                                       = module.eks.cluster_id
  cluster_name                                     = module.eks.cluster_name
  vpc_id                                           = module.eks.vpc_id
  vpc_cidr_block                                   = module.eks.vpc_cidr_block
  vpc_public_subnets                               = module.eks.vpc_public_subnets
  vpc_public_subnets_count                         = module.eks.vpc_public_subnets_count
  ssl_certificate_arn                              = var.ssl_certificate_arn
}