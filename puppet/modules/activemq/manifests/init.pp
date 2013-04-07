class activemq {
package { 'activemq':
  ensure => present
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
}
