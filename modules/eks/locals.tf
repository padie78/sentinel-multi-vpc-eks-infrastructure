locals {
  managed_node_group_settings = {
    # 'general' es el nombre del node group
    general = {
      capacity_type  = var.node_capacity_type
      instance_types = var.instance_types

      min_size     = var.scaling_config.min_size
      max_size     = var.scaling_config.max_size
      desired_size = var.scaling_config.desired_size

      # Roles de Nodo Dinámicos
      create_iam_role = var.create_node_iam_role
      iam_role_arn    = var.create_node_iam_role ? null : var.node_role_arn
      
      # Opcional: Tags específicos para los nodos
      tags = {
        NodeGroup = "general"
      }
    }
  }

  cluster_tags = merge(var.tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}