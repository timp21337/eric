# apt-get install puppet
# puppet module install puppetlabs/apt
# puppet apply site.pp

node default {


  package {['emacs23-nox',
            'cvs', 
            'git',
            'gitg',
            'openssh-server',
            'oracle-j2sdk1.6',
            'curl',
            'texlive',
            'texlive-xetex',
            'texlive-latex-extra',
            'postgresql',
            'scrub',
            'ghc',
            'cabal-install', 
            'chromium-browser',
            'password-gorilla',
  ]:}


  -> 
  exec { "/usr/bin/cabal update": 
    environment => ["HOME=/root"],
    user => root, 
  }
  -> 
  exec { "/usr/bin/cabal install --global cabal-install": 
    environment => ["HOME=/root"],
    user => root, 
  }
  ->
  exec { "/usr/bin/cabal install --global lhs2tex": 
    environment => ["HOME=/root"],
    user => root, 
  }

#  file { "/etc/apt/sources.list.d/google.list":
#    owner => "root",
#    group => "root",
#    mode => 444,
#    content => "deb http://dl.google.com/linux/chrome/deb stable non-free main\n",
#    notify => Exec["Google apt-key"],
#  }

  # Add Google's apt-key.
  # Assumes definition elsewhere of an Exec["apt-get update"] - or
  # uncomment below.
#  exec { "Google apt-key":
#    command => "/usr/bin/wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | /usr/bin/apt-key add -",
#    refreshonly => true,
#    notify => Exec["apt-get update"],
#  }




#  package { "google-chrome-stable":
#    ensure => latest, # to keep current with security updates
#    require => [ Exec["apt-get update"], ],
#  }



  exec { "Jenkins apt-key":
    command => "/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -",
    refreshonly => true,
  }
  ->
  exec { "Jenkins apt sources":
    command => "/bin/echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list",
  }
  ->
  exec { "apt-get update":
    command => "/usr/bin/apt-get update",
    refreshonly => true,
  }
  ->
  package {['jenkins']:}

}

