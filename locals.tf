locals {
  # Definimos las conexiones necesarias
  vpc_peerings = {
    "gw_to_be" = { source_key = "gateway", dest_key = "backend" },
    "be_to_gw" = { source_key = "backend", dest_key = "gateway" }
  }

  security_rules = {
    "gw_to_be_tcp" = {
      type        = "ingress"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      from_vpc    = "gateway"
      dest_eks    = "backend"
      description = "Allow all TCP from Gateway"
    }
  }
}