# apt-get install puppet
# puppet module install puppetlabs/apt
# puppet apply site.pp

node default {


  package {['emacs23-nox',
            'cvs', 
            'git',
            'gitk',
            'gitg',
            'openssh-server',
            'oracle-j2sdk1.6',
            'curl',
            'xchat',
            'texlive',
            'texlive-xetex',
            'texlive-latex-extra',
            'postgresql',
            'pgadmin3',
            'php5',
            'lynx-cur',
            'scrub',
            'ghc',
            'cabal-install', 
            'chromium-browser',
            'password-gorilla',
  ]:}


#  -> 
#  exec { "/usr/bin/cabal update": 
#    environment => ["HOME=/root"],
#    user => root, 
#  }
#  -> 
#  exec { "/usr/bin/cabal install --global cabal-install": 
#    environment => ["HOME=/root"],
#    user => root, 
#  }
#  ->
#  exec { "/usr/bin/cabal install --global lhs2tex": 
#    environment => ["HOME=/root"],
#    user => root, 
#  }

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



#  exec { "Jenkins apt-key":
#    command => "/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -",
#    refreshonly => true,
#  }
#  ->
#  exec { "Jenkins apt sources":
#    command => "/bin/echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list",
#  }
#  ->
#  exec { "apt-get update":
#    command => "/usr/bin/apt-get update",
#    refreshonly => true,
#  }
#  ->
#  package {['jenkins']:}


 $tomcat_version = "7.0.54"
 exec {'download-tomcat':
   command => "/usr/bin/wget -O /usr/local/tomcat-${tomcat_version}.tar.gz http://mirror.ox.ac.uk/sites/rsync.apache.org/tomcat/tomcat-7/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz",
   creates => "/usr/local/tomcat-${tomcat_version}.tar.gz",
 }
 ->
 exec {'unpack-tomcat': 
   command => "/bin/tar xzf /usr/local/tomcat-${tomcat_version}.tar.gz",
   cwd => '/usr/local',
   creates => "/usr/local/tomcat-${tomcat_version}",
 }
 # Then manually move to SSD


 $maven_version = "3.2.2"
 exec {'download-maven':
   command => "/usr/bin/wget -O /usr/local/maven-${maven_version}.tar.gz http://mirror.ox.ac.uk/sites/rsync.apache.org/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz",
   creates => "/usr/local/maven-${maven_version}.tar.gz",
 }
 ->
 exec {'unpack-maven': 
   command => "/bin/tar xzf /usr/local/maven-${maven_version}.tar.gz",
   cwd => '/usr/local',
   creates => "/usr/local/maven-${maven_version}",
 }
 -> 
 file { '/usr/local/maven':
   ensure => 'link',
   target => '/usr/local/maven-${maven_version}',
 }
 -> 
 file { '/usr/local/bin/mvn':
   ensure => 'link',
   target => '/usr/local/maven/bin/mvn',
 }

 $gradle_version = "2.0"
 exec {'download-gradle':
   command => "/usr/bin/wget -O /usr/local/gradle-${gradle_version}.zip https://services.gradle.org/distributions/gradle-${gradle_version}-all.zip",
   creates => "/usr/local/gradle-${gradle_version}.zip",
 }
 ->
 exec {'unpack-gradle': 
   command => "/usr/bin/unzip /usr/local/gradle-${gradle_version}.zip",
   cwd => '/usr/local',
   creates => "/usr/local/gradle-${gradle_version}",
 }
 -> 
 file { '/usr/local/gradle':
   ensure => 'link',
   target => '/usr/local/gradle-${gradle_version}',
 }
 -> 
 file { '/usr/local/bin/gradle':
   ensure => 'link',
   target => '/usr/local/gradle/bin/gradle',
 }

 $idea_version = "13.1.4b"
 exec {'download-idea':
   command => "/usr/bin/wget -O /usr/local/idea-${idea_version}.tar.gz http://download.jetbrains.com/idea/ideaIU-${idea_version}.tar.gz",
   creates => "/usr/local/idea-${idea_version}.tar.gz",
 }
 ->
 exec {'unpack-idea': 
   command => "/bin/tar xzf /usr/local/idea-${idea_version}.tar.gz",
   cwd => '/usr/local',
   creates => "/usr/local/idea-${idea_version}",
 }
 -> 
 file { '/usr/local/idea':
   ensure => 'link',
   target => '/usr/local/idea-${idea_version}',
 }
 -> 
 file { '/usr/local/bin/idea':
   ensure => 'link',
   target => '/usr/local/idea/bin/idea',
 }

}

# Setup ssd
# mv .cache /scratch/home/timp/cache
# ln -s /scratch/home/timp/cache .cache
#
# mv scratch/git /scratch/home/timp/
# mv scratch/bbm /scratch/home/timp/

