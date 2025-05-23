variable "azureRG" {
  description = "Resource group name"
  type        = string
  default     = "RG-02"

}

variable "AzureVnet" {
  description = "Azure Virtual Network"
  type        = string
  default     = "VNET"

}

variable "AzureSubnet" {
  description = "Azure Subnet"
  type        = string
  default     = "Subnet-01"

}