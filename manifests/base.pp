exec { 'apt-update':
  command => '/usr/bin/apt-get update'
}

package { 'activemq':
  ensure => present,
  before => Service['activemq'],
  require => Exec['apt-update']
}

file { '/etc/activemq/instances-enabled/main':
  ensure => link,
  target => '/etc/activemq/instances-available/main',
  require => Package['activemq']
}

file { '/etc/activemq/instances-enabled/main/activemq.xml':
  source => 'puppet:///modules/activemq/activemq.xml',
  require => File['/etc/activemq/instances-enabled/main']
}


service { 'activemq':
  ensure => running,
  enable => true,
  hasstatus => false,
  hasrestart => true,
  subscribe  => File['/etc/activemq/instances-enabled/main/activemq.xml']
}