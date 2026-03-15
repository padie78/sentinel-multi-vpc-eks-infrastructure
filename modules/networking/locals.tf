locals {
  # Nombre base para todos los recursos
  # Ejemplo: sentinel-vpc-gateway
  name_prefix = "${var.project_name}-${var.vpc_name}"

  # Tags que se repiten en todos los recursos
  common_tags = merge(var.tags, {
    VPC_Group    = var.vpc_name
    Project      = var.project_name
    Provisioner  = "Terraform"
  })

  # Tags específicos para que EKS gestione LBs (Ingress/Service)
  eks_public_tags  = { "kubernetes.io/role/elb" = "1" }
  eks_private_tags = { "kubernetes.io/role/internal-elb" = "1" }
}