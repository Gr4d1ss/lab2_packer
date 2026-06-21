Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu18application"
  
  # Отключаем автообновление Guest Additions
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  
  # Отключаем общую папку (не работает из-за несовместимости Guest Additions)
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  config.vm.define "application" do |application|
    application.vm.box = "ubuntu18application"
    config.ssh.username = 'vagrant'
    config.ssh.password = 'vagrant'
    config.ssh.insert_key = false
    
    # Сетевые настройки
    application.vm.network "private_network", ip: "10.0.0.200"
    
    # Проброс портов для приложения
    application.vm.network "forwarded_port", guest: 8080, host: 8083, host_ip: "127.0.0.1"
    
    # Автозапуск Redis и приложения при старте VM
    $script = <<-SCRIPT
    echo "Provisioning: Starting Redis and Application..."
    sudo service redis-server start
    cd /home/vagrant/ddd2023/compose
    nohup python3 app/app.py < /dev/null > /tmp/flask.log 2>&1 &
    echo "Provisioning completed!"
    SCRIPT
    
    application.vm.provision "shell", inline: $script
  end
end
