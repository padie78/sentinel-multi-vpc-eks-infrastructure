variable "project_name" {
  description = "Nombre del proyecto para prefijos de recursos"
  type        = string
}

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR principal de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_dest_cidr" {
  description = "Destino para la ruta pública (default internet)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_dest_cidr" {
  description = "Destino para la ruta privada (default internet vía NAT)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_subnet_count" {
  description = "Cantidad de subnets públicas"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Cantidad de subnets privadas"
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway para las subnets privadas"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Indica si las instancias en la VPC reciben nombres de host DNS públicos"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Indica si el soporte de resolución de DNS de AWS está habilitado"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionales para los recursos"
  type        = map(string)
  default     = {}
}