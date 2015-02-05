class configure {
  exec { "update_and_upgrade":
    command => "/usr/bin/apt-get -q update && /usr/bin/apt-get upgrade"
  }

  package { 'java8-runtime':
    ensure => installed
  }

  package { 'elasticsearch':
    ensure => installed
  }

  package { 'logstash':
    ensure => installed
  }

  service { 'elasticsearch':
    require => Package[
      'elasticsearch',
      'java8-runtime'
    ],
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
  }

  service { 'logstash':
    require => Service['elasticsearch'],
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
  }
}
