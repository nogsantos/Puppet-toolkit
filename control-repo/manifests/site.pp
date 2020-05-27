node 'centos-7.local' {
  package { 'httpd':
    ensure => installed,
  }

  file { 'teste':
    ensure  => present,
    path    => '/tmp/teste.txt',
    mode    => '0640',
    content => "Conteudo de teste!\n",
    # notify  => Service['sshd'],
  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  notify {'notificacao':
    message => 'Gerando uma notificação!'
  }

  # Define uma ordem de execução, por encadeamento
  File['teste'] -> Service['sshd'] -> Notify['notificacao']

  # Validando antes da aplicação
  package {'sudo':
    ensure => 'installed'
  }

  # file {'/etc/sudoers':
  #   ensure  => 'file',
  #   mode    => '0440',
  #   owner   => 'root',
  #   group   => 'root',
  #   source  => 'sudoers',
  #   require => [Package['sudo'], Exec['parse_sudoers']],
  # }

  # exec {'parse_sudoers':
  #   command => '/usr/sbin/visudo -c -f sudoers',
  #   unless  => '/usr/bin/diff sudoers /etc/sudoers',
  #   require => Package['sudo'],
  # }

  # -> Facter

  # Obtendo o nome do S.O e a versao do kernel
  # Esses dados estao nos fatos: kernel e kernelversion
  notify {'kernel':
    message => "O sistema operacional ${::kernel} versao ${::kernelversion}."
  }

  # Obtendo o nome da distro GNU/Linux
  # Esse dados estao nos fatos: operatingsystem e operatingsystemrelease
  notify {'distro':
    message => "A distribuicao GNU/Linux ${::operatingsystem} versão ${::operatingsystemrelease}."}

  # Obtendo o tipo de instalacao, se virtual ou fisica
  notify {'virtual':
    message => "Maquina virtual? ${::is_virtual} tipo: ${::virtual}"
  }

  # -> Condições

  package {'ntp':
    ensure => 'installed',
  }

  if $::osfamily == 'RedHat' {
    service {'ntpd':
      ensure => 'running',
      enable => 'true',
      notify => Notify['redhatdistro'],
    }

    notify {'redhatdistro':
      message => 'Distribuição base RedHat'
    }
  }
  elsif $::osfamily == 'Debian' {
    service {'ntp':
      ensure => 'running',
      enable => 'true',
      notify => Notify['redhatdistro'],
    }

    notify {'debiandistro':
      message => 'Distribuição base Debian'
    }
  }
}
