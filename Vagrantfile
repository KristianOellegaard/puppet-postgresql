# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	['master', 'slave'].each do |vm_name|
		config.vm.define vm_name do |cfg|
			cfg.vm.box = 'base_fusion'
			cfg.vm.hostname = vm_name

			cfg.vm.synced_folder('test-modules', '/tmp/vagrant-puppet/modules-0/')
			cfg.vm.synced_folder('.', '/tmp/vagrant-puppet/modules-1/postgresql')
			cfg.vm.provision :shell,
				:inline => "sudo apt-get update; cd /tmp/vagrant-puppet/modules-1/postgresql && puppet apply --modulepath '/tmp/vagrant-puppet/modules-1:/etc/puppet/modules:/tmp/vagrant-puppet/modules-0' test.pp -v --pluginsync; cat /var/log/postgresql/postgresql-9.1-main.log"
		end
	end
end
