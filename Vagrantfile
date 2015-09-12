# Set our default provider for this Vagrantfile to 'vmware_appcatalyst'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'vmware_appcatalyst'

nodes = [
  { hostname: 'hap-01', box: 'hashicorp/precise64' },
  { hostname: 'web-01', box: 'hashicorp/precise64' },
  { hostname: 'web-02', box: 'hashicorp/precise64' },
]

Vagrant.configure('2') do |config|

  # Use custom SSH key
  # config.ssh.private_key_path = "~/.ssh/id_rsa"
  # config.ssh.insert_key = true

  # Configure boxes with 1 CPU and 384MB of RAM
  config.vm.provider 'vmware_appcatalyst' do |v|
    v.cpus = '1'
    v.memory = '384'
  end

  # Go through nodes and configure each of them.j
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.hostname = node[:hostname]
#     node_config.vm.synced_folder('/Users/user/Development', '/development')
    end
    
    config.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines("ssh-key/vagrant.pub").first.strip
        s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        SHELL
    end
  end
  
  
end
