class configure {
  exec { 'update_and_upgrade':
    require => File[
      '/etc/apt/sources.list.d/elasticsearch.list',
      '/etc/apt/sources.list.d/logstash.list'
    ],
    before  => Package[
      'java8-runtime',
      'elasticsearch',
      'logstash'
    ],
    command => "/usr/bin/apt-get -q -y update && /usr/bin/apt-get -q -y upgrade"
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

  package { 'rsyslog':
    ensure => installed
  }

  package { 'haproxy':
    ensure => installed
  }

  file_line { 'elasticsearch.http.cors.enabled':
    require => Package['elasticsearch'],
    path => '/etc/elasticsearch/elasticsearch.yml',
    line => 'http.cors.enabled: true',
  }

  file { '/etc/haproxy/haproxy.cfg':
    require => Package['haproxy'],
    owner => "root",
    group => "root",
    mode  => 644,
    source => "puppet:///modules/configure/haproxy.cfg"
  }

  file_line { 'haproxy_logging':
    require => Package['haproxy', 'rsyslog'],
    path    => '/etc/rsyslog.d/49-haproxy.conf',
    line    => "if $programname startswith 'haproxy' then @@127.0.0.1:5140    # Send HAProxy messages to logstash"
  }

  file { '/etc/default/logstash-web':
    require => Package['logstash'],
    content => 'LS_LOG_FILE=""    # Prevent logstash-web from throwing "OptionParser::InvalidOption: invalid option: -l"'
  }

  file { '/etc/logstash/conf.d/logherder.conf':
    require => Package['logstash'],
    owner => "root",
    group => "root",
    mode  => 644,
    source => "puppet:///modules/configure/logherder.conf"
  }

  service { 'elasticsearch':
    require => [
      File_Line['elasticsearch.http.cors.enabled'],
      Package['java8-runtime']
    ],
    ensure => running,
    enable => true,
    hasrestart => true,
  }

  service { 'logstash':
    require => [
      Service['elasticsearch'],
      Package['logstash'],
      File['/etc/default/logstash-web', '/etc/logstash/conf.d/logherder.conf'],
      File_Line['haproxy_logging']
    ],
    ensure => running,
    enable => true,
    hasrestart => true,
  }

  service { 'logstash-web':
    require => Service['logstash'],
    ensure => running,
    enable => true,
    hasrestart => true,
  }

  service { 'haproxy':
    require => [
      Service['logstash', 'logstash-web'],
      Package['haproxy']
    ],
    ensure => running,
    hasrestart => true,
  }

}
