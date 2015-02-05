class apt-setup {

  exec { 'elasticsearch.org_key':
    command => "/usr/bin/wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | /usr/bin/apt-key add -"
  }

  file { '/etc/apt/sources.list.d/elasticsearch.list':
    require => Exec['elasticsearch.org_key'],
    owner => "root",
    group => "root",
    mode  => 644,
    content => "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main"
  }

  file { '/etc/apt/sources.list.d/logstash.list':
    require => Exec['elasticsearch.org_key'],
    owner => "root",
    group => "root",
    mode  => 644,
    content => "deb http://packages.elasticsearch.org/logstash/1.4/debian stable main"
  }

}
