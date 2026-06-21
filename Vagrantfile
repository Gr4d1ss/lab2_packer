Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu18application"
  
  # Отключаем автообновление Guest Additions
  # Плагин vagrant-vbguest остаётся установленным, но не мешает запуску
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
  end
end
