variable "name" {
  description = "Name of the repository"
  type        = string
}

variable "encryption_configuration" {
  description = "Encryption configuration for the repository"
  default     = null
  type = object({
    encryption_type = string,
    kms_key         = string
  })
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images. Defaults to false"
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  type        = string
  default     = "MUTABLE"
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  default     = {}
}
