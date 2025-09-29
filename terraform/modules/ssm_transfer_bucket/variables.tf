variable "bucket_name" {
  description = "Nombre del bucket S3 para transferencias SSM"
  type        = string
}

variable "region" {
  description = "Región AWS donde se crea el bucket"
  type        = string
}

variable "tags" {
  description = "Etiquetas comunes para recursos"
  type        = map(string)
  default     = {}
}

