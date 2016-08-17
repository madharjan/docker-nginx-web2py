# -*- mode: ruby -*-
# vi: set ft=ruby :

$vm_name = "ubuntu-14.04-nginx-web2py"
$vm_gui = false
$vm_memory = 768
$vm_cpus = 1
$vm_proxy = true
$vm_guest = true
#$network_prefix = "192.168.56."
#$ip_start = 100
$forwarded_ports = {80 => 8080}

CLOUD_META_PATH = "./cloud-init/meta-data"
CLOUD_CONF_PATH = "./cloud-init/user-data"

$CLOUD_INIT = <<SCRIPT

rm -rf /var/lib/cloud/instances
rm -rf /var/lib/cloud/instance
rm -rf /var/lib/cloud/data
rm -rf /var/log/cloud-init.log
rm -rf /var/log/cloud-init-output.log

cloud-init init
cloud-init modules --mode config
cloud-init modules --mode final
SCRIPT

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu-14.04"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.box_check_update = false

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  if $forwarded_ports
    $forwarded_ports.each do |guest, host|
      config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
    end
  end

  # config.vm.network "private_network", ip: "192.168.56.100"
  if $ip_start
    ip = ($network_prefix + "#{$ip_start}")
    config.vm.network :private_network, ip: ip
  end

  # config.vm.network "public_network"
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    vb.name = $vm_name
    vb.gui = $vm_gui
    vb.memory = $vm_memory
    vb.cpus = $vm_cpus
    vb.customize ["modifyvm", :id, "--vram", "2"]

    vb.check_guest_additions = $vm_guest
    vb.functional_vboxsf     = $vm_guest
  end

  if Vagrant.has_plugin?("vagrant-proxyconf")
      config.proxy.enabled = $vm_proxy
      config.proxy.http = ENV["http_proxy"] || ""
      config.proxy.https = ENV["http_proxy"] || ""
      config.proxy.no_proxy = ENV["no_proxy"] || ""
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = $vm_guest
  end

  if File.exist?(CLOUD_META_PATH)
    config.vm.provision :file, :source => "#{CLOUD_META_PATH}", :destination => "/tmp/vagrantfile-meta-data"
    config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-meta-data /var/lib/cloud/seed/nocloud-net/meta-data", :privileged => true
  end
  if File.exist?(CLOUD_CONF_PATH)
    config.vm.provision :file, :source => "#{CLOUD_CONF_PATH}", :destination => "/tmp/vagrantfile-user-data"
    config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/cloud/seed/nocloud-net/user-data", :privileged => true
    config.vm.provision :shell, :inline => $CLOUD_INIT
  end
end
