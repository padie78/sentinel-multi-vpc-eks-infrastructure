variable "project_name" {
  description = "Nombre del proyecto para prefijos y etiquetas"
  type        = string
  default     = "sentinel"
}

variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}