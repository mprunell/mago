# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

    config.vm.host_name = "mago"
    config.vm.box = "trusty64"
    config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]

    # Set the puppet version to the last one
    config.vm.provision :shell, :path => "setup/scripts/bootstrap_puppet.sh"


    config.vm.define :dev do |master_config|

        master_config.vm.share_folder "project", "/home/vagrant/mago/source", "."

        master_config.vm.forward_port 80,    8000    # app
        master_config.vm.forward_port 5432,  5433    # postgres
        
        master_config.vm.provision :puppet do |puppet|
		puppet.manifests_path = "setup"
		puppet.module_path = "setup/modules"
		puppet.manifest_file  = "dev.pp"
		puppet.options = "--verbose --debug"
        end

    end

end
