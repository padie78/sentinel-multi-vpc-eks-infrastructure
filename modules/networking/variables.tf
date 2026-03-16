# ==========================================
# 1. IDENTIFICATION
# ==========================================

variable "project_name" {
  type        = string
  description = "Project identifier used for resource naming prefixes"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC (e.g., gateway, main)"
}

# ==========================================
# 2. NETWORK ADDRESSING
# ==========================================

variable "vpc_cidr" {
  type        = string
  description = "Primary CIDR block for the VPC"
}

variable "public_dest_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Destination CIDR for public routing (typically the internet)"
}

variable "private_dest_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Destination CIDR for private routing (typically internet via NAT)"
}

# ==========================================
# 3. SUBNET & GATEWAY CONFIGURATION
# ==========================================

variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets to deploy across AZs"
}

variable "private_subnet_count" {
  type        = number
  description = "Number of private subnets to deploy across AZs"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Flag to enable/disable NAT Gateway for private subnet outbound traffic"
}

# ==========================================
# 4. VPC ATTRIBUTES
# ==========================================

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Whether to enable DNS hostnames in the VPC"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Whether to enable DNS support in the VPC"
}

# ==========================================
# 5. METADATA
# ==========================================

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of additional tags to apply to all resources"
}