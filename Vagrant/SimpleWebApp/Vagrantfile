Vagrant.configure("2") do |config|
    # Base box
    config.vm.box = "eurolinux-vagrant/centos-stream-9"
    config.vm.hostname = "Centos"

    # Private network with static IP
    config.vm.network "private_network", ip: "192.168.56.28"

    # Bridged/public network without static IP
    # Vagrant will prompt to select the host adapter unless you set `bridge: "NAME_OF_ADAPTER"`
    config.vm.network "public_network", bridge: "en0: Ethernet"

    # Provider-specific settings for VirtualBox
    config.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
    end
   # Setup commands 
    config.vm.provision "shell", inline: <<-SHELL
        yum install httpd unzip wget -y
        systemctl start httpd
        systemctl enable httpd
        mkdir -p /tmp/webpage
        cd /tmp/webpage
        wget https://www.tooplate.com/zip-templates/2142_cloud_sync.zip
        unzip -o 2142_cloud_sync.zip
        cp -r 2142_cloud_sync/* /var/www/html/
        systemctl restart httpd
        cd /
        rm -rf /tmp/webpage
    SHELL
 
end