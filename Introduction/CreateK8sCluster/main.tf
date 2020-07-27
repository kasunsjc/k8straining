provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "kubeadmcluster" {
  name     = "K8s-Kubeadm"
  location = "East US 2"
}

resource "azurerm_virtual_network" "k8s-network" {
  name                = "k8-network-test"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.kubeadmcluster.location
  resource_group_name = azurerm_resource_group.kubeadmcluster.name
}

resource "azurerm_subnet" "servers" {
  name                 = "server-subnet"
  resource_group_name  = azurerm_resource_group.kubeadmcluster.name
  virtual_network_name = azurerm_virtual_network.k8s-network.name
  address_prefix       = "10.20.2.0/24"
}

resource "azurerm_public_ip" "masternode-pip" {
  name                = "masternode-pip"
  location            = azurerm_resource_group.kubeadmcluster.location
  resource_group_name = azurerm_resource_group.kubeadmcluster.name
  allocation_method   = "Static"
  domain_name_label   = "masternodetest"
}

resource "azurerm_public_ip" "workernode-pip" {
  count = 2
  name                = "workernode-${count.index}-pip"
  location            = azurerm_resource_group.kubeadmcluster.location
  resource_group_name = azurerm_resource_group.kubeadmcluster.name
  allocation_method   = "Static"
  domain_name_label   = "workernodetest${count.index}"
}


resource "azurerm_network_interface" "master-nic" {
  count               = 1
  name                = "master-nic-${count.index}"
  location            = azurerm_resource_group.kubeadmcluster.location
  resource_group_name = azurerm_resource_group.kubeadmcluster.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.servers.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.masternode-pip.id
  }
}

resource "azurerm_network_interface" "worker-nic" {
  count               = 2
  name                = "worker-nic-${count.index}"
  location            = azurerm_resource_group.kubeadmcluster.location
  resource_group_name = azurerm_resource_group.kubeadmcluster.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.servers.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = azurerm_public_ip.workernode-pip[count.index].id
  }
}


#Create Master Node
resource "azurerm_virtual_machine" "masternodes" {
  count                 = 1
  name                  = "MasterK8s-0${count.index}"
  location              = azurerm_resource_group.kubeadmcluster.location
  resource_group_name   = azurerm_resource_group.kubeadmcluster.name
  network_interface_ids = [element(azurerm_network_interface.master-nic.*.id, count.index)]
  vm_size               = "Standard_B2s" #change to B2s

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "masternode-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }


  os_profile {
    computer_name  = "MasterK8s-0${count.index}"
    admin_username = "localadmin"
    admin_password = "Password1234!"
    custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "dev"
  }
}

#Create Worker Node
resource "azurerm_virtual_machine" "workernodes" {
  count                 = 2
  name                  = "WorkerK8s-0${count.index}"
  location              = azurerm_resource_group.kubeadmcluster.location
  resource_group_name   = azurerm_resource_group.kubeadmcluster.name
  network_interface_ids = [element(azurerm_network_interface.worker-nic.*.id, count.index)]
  vm_size               = "Standard_B2s" #change to B2s

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "workernode-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }


  os_profile {
    computer_name  = "WorkerK8s-0${count.index}"
    admin_username = "localadmin"
    admin_password = "Password1234!"
    custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "dev"
  }
}

# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("cloud-init-ubuntu.sh")
}

