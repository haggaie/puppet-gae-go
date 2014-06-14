class gae-go {

	package {'python2.7':
		ensure => present
	}

  package {'wget':
		ensure => present
	}

	package { "unzip":
		ensure  => present,
	}

	case $architecture {
		'i386':  { $filename = 'go_appengine_sdk_linux_386-1.9.6.zip' }
		'amd64': { $filename = 'go_appengine_sdk_linux_amd64-1.9.6.zip' }
	}

	$url = 'https://storage.googleapis.com/appengine-sdks/featured/${filename}'

	exec {"grab-gaesdk":
		command => "/usr/bin/wget https://storage.googleapis.com/appengine-sdks/featured/${filename}",
		cwd     => "/usr/local/src/",
		creates => "/usr/local/src/${filename}",
		umask   => "2",
		require => Package["wget"]
	}

	exec { "unzip-gae":
		command => "/usr/bin/unzip ${filename} && chmod 755 go_appengine",
		cwd     => "/usr/local/src/",
		creates => "/usr/local/src/google_appengine",
		umask   => "2",
		require => [Exec["grab-gaesdk"], Package["unzip"]]
	}
}
