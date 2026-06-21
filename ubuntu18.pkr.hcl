# ============================================================================
# Packer шаблон для создания образа Ubuntu 18.04 с приложением
# Формат: HCL2 (HashiCorp Configuration Language)
# ============================================================================

# ----------------------------------------------------------------------------
# Секция source: описание источника образа (билдер)
# Определяет, на какой платформе и с какими параметрами создаётся VM
# ----------------------------------------------------------------------------
source "virtualbox-iso" "ubuntu-18-04" {
  # Тип билдера - создаём образ из ISO файла для VirtualBox
  vm_name = "packer-ubuntu-18.04.1-amd64"

  # Тип гостевой ОС для VirtualBox (64-битная Ubuntu)
  guest_os_type = "Ubuntu_64"

  # Размер виртуального диска в МБ (80 ГБ)
  disk_size = 81920

  # Путь к ISO образу Ubuntu
  iso_urls = ["iso/ubuntu-18.04.1-server-amd64.iso"]

  # Контрольная сумма ISO для проверки целостности
  iso_checksum = "sha256:a5b0ea5918f850124f3d72ef4b85bda82f0fcd02ec721be19c1a6952791c8ee8"

  # Папка с файлами для автоматической установки (preseed.cfg)
  http_directory = "http"

  # Команды, отправляемые в консоль при загрузке для автоустановки
  boot_command = [
    "<esc><wait>",
    "<esc><wait>",
    "<enter><wait>",
    "/install/vmlinuz<wait>",
    " auto<wait>",
    " console-setup/ask_detect=false<wait>",
    " console-setup/layoutcode=us<wait>",
    " console-setup/modelcode=pc105<wait>",
    " debconf/frontend=noninteractive<wait>",
    " debian-installer=en_US<wait>",
    " fb=false<wait>",
    " initrd=/install/initrd.gz<wait>",
    " kbd-chooser/method=us<wait>",
    " keyboard-configuration/layout=USA<wait>",
    " keyboard-configuration/variant=USA<wait>",
    " locale=en_US<wait>",
    " netcfg/get_domain=vm<wait>",
    " netcfg/get_hostname=vagrant<wait>",
    " grub-installer/bootdev=/dev/sda<wait>",
    " noapic<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    " --<wait>",
    "<enter><wait>"
  ]

  # Время ожидания перед отправкой boot_command
  boot_wait = "10s"

  # Запускать ли VM без графического интерфейса (false = показывать окно)
  headless = false

  # Учётные данные для SSH подключения к VM во время provisioning
  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_port     = 22

  # Максимальное время ожидания доступности SSH (10000 секунд ≈ 2.7 часа)
  ssh_wait_timeout = "10000s"

  # Команда для корректного выключения VM после provisioning
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"

  # Путь к VirtualBox Guest Additions ISO
  guest_additions_path = "VBoxGuestAdditions_{{ .Version }}.iso"

  # Файл для сохранения версии VirtualBox
  virtualbox_version_file = ".vbox_version"

  # Дополнительные команды VBoxManage для настройки VM
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--cpus", "2"],
    ["modifyvm", "{{ .Name }}", "--nat-localhostreachable1", "on"]
  ]
}

# ----------------------------------------------------------------------------
# Секция build: определение процесса сборки
# Указывает, какой source использовать и какие provisioners/post-processors применить
# ----------------------------------------------------------------------------
build {
  # Используем описанный выше source
  sources = ["source.virtualbox-iso.ubuntu-18-04"]

  # ----------------------------------------------------------------------------
  # Provisioners: скрипты для установки и настройки ПО внутри VM
  # Каждый скрипт выполняется с правами sudo через пользователя vagrant
  # ----------------------------------------------------------------------------

  # Начальная настройка системы (обновление пакетов, базовые настройки)
  provisioner "shell" {
    script          = "scripts/init.sh"
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
  }

  # Установка curl (утилита для HTTP-запросов)
  provisioner "shell" {
    script          = "scripts/install_curl.sh"
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
  }

  # Установка git (система контроля версий)
  provisioner "shell" {
    script          = "scripts/install_git.sh"
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
  }

  # Установка Redis (сервер кэширования для приложения)
  provisioner "shell" {
    script          = "scripts/install_redis.sh"
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
  }

  # Установка pip3 (менеджер пакетов Python)
  provisioner "shell" {
    script          = "scripts/install_pip3.sh"
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
  }

  # Установка самого Flask-приложения из репозитория
  provisioner "shell" {
    script          = "scripts/install_application.sh"
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
  }

  # Очистка системы (удаление временных файлов, кэша apt)
  provisioner "shell" {
    script          = "scripts/cleanup.sh"
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
  }

  # ----------------------------------------------------------------------------
  # Post-processor: создание Vagrant box из собранного образа
  # ----------------------------------------------------------------------------
  post-processor "vagrant" {
    output = "output/ubuntu-18.04.application.box"
  }
}
