variable "rg_name" {
  default     = "rg-example"
  description = "Resource group name"
}

variable "az_region" {
  default     = "North Europe"
  description = "Azure region"
}

variable "img_publisher" {
  default     = "Canonical"
  description = "Azure platform image publisher"
}

variable "img_offer" {
  default     = "0001-com-ubuntu-server-focal"
}

variable "img_sku" {
  default     = "20_04-lts"
}

variable "virtual_net" {
  default = "vnet"
  description = "Virtual network name"
}

variable "subnet" {
  default = "subnet-example"
}

variable "pub_ip_cnt" {
  type        = number
  default     = 2
  description = "Count of vm public ip"
}

variable "pub_ip_alloc_method" {
  default = "Static"
  description = "Public IP allocation method"
}

variable "ip_sku" {
  default = "Basic"
}

variable "nic_cnt" {
  type        = number
  default     = 2
  description = "Count of Network Interface"
}

variable "priv_ip_alloc" {
  default     = "Dynamic"
  description = "Net interface priv ip allocation method"
}

variable "nsg" {
  default     = "sg-example"
  description = "Network Security Group name"
}


variable "sg_rule_1_name" {
  default     = "Allow-port-22"
  description = "Name of NSG rule-1"
}

variable "sg_rule_2_name" {
  default     = "Allow-port-80"
  description = "Name of NSG rule-2"
}

variable "sg_rule_3_name" {
  default     = "Argo-app-nodeport"
  description = "Allow argo-app nodeport"
}

variable "sg_rule_4_name" {
  default     = "Base-app-nodeport"
  description = "Allow base-app nodeport"
}


variable "sg_rule_1_prt" {
  type = number
  default     = 100
  description = "NSG rule-1 priority number"
}

variable "sg_rule_2_prt" {
  type = number
  default     = 110
  description = "NSG rule-2 priority number"
}

variable "sg_rule_3_prt" {
  type = number
  default     = 120
  description = "NSG rule-3 priority number"
}

variable "sg_rule_4_prt" {
  type = number
  default     = 130
  description = "NSG rule-4 priority number"
}

variable "argo-app-nodeport" {
  type = number
  default = 30009
  description = "Argo app svc nodeport number"
}

variable "base-app-nodeport" {
  type = number
  default = 30008
  description = "Argo app svc nodeport number"
}


variable "sg_rule_type" {
  default     = "Inbound"
}

variable "sg_rule_access" {
  default     = "Allow"
  description = "Allow or deny access"
}


variable "sg_rule_protocol" {
  default = "Tcp"
}

variable "sg_src_port_range" {
  default = "*"
  description = "NSG rule source port range"
}

variable "addr_prefix" {
  default = "*"
  description = "NSG src/dest address prefix"
}

variable "sg_dest_port_range" {
  default = "22"
  description = "NSG rule destination port range"
}

variable "ass_cnt" {
  type        = number
  default     = 2
  description = "NSG-NI-association resource count"
}

variable "vm_name" {
  type        = string
  default     = "azure-vm"
  description = "Name of Azure RM virtual machine"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "vm_cnt" {
  type        = number
  default     = 2
  description = "Virtual Machine count"
}

variable "admin_uname" {
  default     = "azureuser"
  description = "VM admin username"
}

variable "os_disk_caching" {
  default     = "ReadWrite"
  description = "VM os_disk caching"
}

variable "os_disk_sa" {
  default     = "Standard_LRS"
  description = "OS disk storage account type"
}

