variable "project_name" {
  description = "Nombre del proyecto para los prefijos (ej: sentinel)"
  type        = string
  default     = "sentinel"
}

variable "tags" {
  description = "Mapa de etiquetas para los recursos"
  type        = map(string)
  default     = {
    Project = "Rapyd-Sentinel"
    Owner   = "Diego-Liascovich"
  }
}