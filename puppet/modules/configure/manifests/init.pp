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

  file_line { 'elasticsearch.http.cors.enabled':
    require => Package['elasticsearch'],
    path => '/etc/elasticsearch/elasticsearch.yml',
    line => 'http.cors.enabled: true',
  }

  service { 'elasticsearch':
    require => [
      File_Line['elasticsearch.http.cors.enabled'],
      Package['java8-runtime']
    ],
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
  }

  service { 'logstash':
    require => [
      Service['elasticsearch'],
      Package['logstash']
    ],
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
  }

  service { 'logstash-web':
    require => Service['logstash'],
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
  }
}
