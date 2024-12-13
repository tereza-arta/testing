resource "azurerm_resource_group" "some" {
  name     = var.rg_name
  location = var.az_region
}

data "azurerm_platform_image" "platform_img" {
  location  = azurerm_resource_group.some.location
  publisher = var.img_publisher
  offer     = var.img_offer
  sku       = var.img_sku
}

resource "azurerm_virtual_network" "net" {
  name                = var.virtual_net
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.some.location
  resource_group_name = azurerm_resource_group.some.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.some.name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "ip" {
  count = var.pub_ip_cnt
  name  = "pub-ip-${count.index + 1}"
  #name = "mpub-ip-1"
  location            = azurerm_resource_group.some.location
  resource_group_name = azurerm_resource_group.some.name
  allocation_method   = var.pub_ip_alloc_method
  sku                 = var.ip_sku
}

resource "azurerm_network_interface" "nic" {
  count = var.nic_cnt
  name  = "nic-${count.index + 1}"
  #name = "mnic-1"
  location            = azurerm_resource_group.some.location
  resource_group_name = azurerm_resource_group.some.name

  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.priv_ip_alloc
    public_ip_address_id          = azurerm_public_ip.ip[count.index].id
    #public_ip_address_id = azurerm_public_ip.ip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = azurerm_resource_group.some.location
  resource_group_name = azurerm_resource_group.some.name
}

resource "azurerm_network_security_rule" "for-ssh" {
  name                        = var.sg_rule_1_name
  priority                    = var.sg_rule_1_prt
  direction                   = var.sg_rule_type
  access                      = var.sg_rule_access
  protocol                    = var.sg_rule_protocol
  source_port_range           = var.sg_src_port_range
  destination_port_range      = var.sg_dest_port_range
  source_address_prefix       = var.addr_prefix
  destination_address_prefix  = var.addr_prefix
  resource_group_name         = azurerm_resource_group.some.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "for-http" {
  name                        = var.sg_rule_2_name
  priority                    = var.sg_rule_2_prt
  direction                   = var.sg_rule_type
  access                      = var.sg_rule_access
  protocol                    = var.sg_rule_protocol
  source_port_range           = var.sg_src_port_range
  destination_port_range      = var.sg_dest_port_range
  source_address_prefix       = var.addr_prefix
  destination_address_prefix  = var.addr_prefix
  resource_group_name         = azurerm_resource_group.some.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "np" {
  name                        = var.sg_rule_3_name
  priority                    = var.sg_rule_3_prt
  direction                   = var.sg_rule_type
  access                      = var.sg_rule_access
  protocol                    = var.sg_rule_protocol
  source_port_range           = var.sg_src_port_range
  destination_port_range      = var.argo-app-nodeport
  source_address_prefix       = var.addr_prefix
  destination_address_prefix  = var.addr_prefix
  resource_group_name         = azurerm_resource_group.some.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "np-2" {
  name                        = var.sg_rule_4_name
  priority                    = var.sg_rule_4_prt
  direction                   = var.sg_rule_type
  access                      = var.sg_rule_access
  protocol                    = var.sg_rule_protocol
  source_port_range           = var.sg_src_port_range
  destination_port_range      = var.base-app-nodeport
  source_address_prefix       = var.addr_prefix
  destination_address_prefix  = var.addr_prefix
  resource_group_name         = azurerm_resource_group.some.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


resource "azurerm_network_interface_security_group_association" "nsg-nic" {
  count                     = var.ass_cnt
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count = var.vm_cnt
  name  = format("%s-%d", var.vm_name, count.index + 1)
  #name = "azure-vm-1"
  resource_group_name   = azurerm_resource_group.some.name
  location              = azurerm_resource_group.some.location
  size                  = var.vm_size
  admin_username        = var.admin_uname
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  #network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_uname
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_sa
  }

  source_image_reference {
    publisher = data.azurerm_platform_image.platform_img.publisher
    offer     = data.azurerm_platform_image.platform_img.offer
    sku       = data.azurerm_platform_image.platform_img.sku
    version   = data.azurerm_platform_image.platform_img.version
  }
}
