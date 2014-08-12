# apt-get install puppet
# puppet module install puppetlabs/apt
# puppet apply site.pp

node default {

  file { "/etc/apt/sources.list.d/mediagraft.list":
    owner => "root",
    group => "root",
    mode => 444,
    content => "
# Created with puppet

deb http://testing-cluster:FTx1koUQ@packages.mediagraft.com/repo wheezy/stable main contrib non-free
deb-src http://testing-cluster:FTx1koUQ@packages.mediagraft.com/repo wheezy/stable main contrib non-free

",
  }

->
  file { "/etc/apt/apt.conf":
    owner => "root",
    group => "root",
    mode => 444,
    content => "
# Created from eric with puppet

APT::Get::AllowUnauthenticated \"true\";

",
  }

->
  exec { "apt-get update for mediagraft":
    command => "/usr/bin/apt-get update",
    refreshonly => true,
  }
->
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
            'php5-dev',
            'php5-cli',
            'php-getid3',  
            'lynx-cur',
            'scrub',
            'ghc',
            'haskell-mode',
            'libghc-zlib-dev',
            'zlib1g-dev',
            'cabal-install', 
            'chromium-browser',
            'password-gorilla',
            'vagrant',
            'virtualbox',
   ]:
  }



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


   exec { "Ensure video read writable": 
     command => "/bin/chmod o+rw /dev/video0";
   }


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
  exec { "apt-get update after jenkins":
    command => "/usr/bin/apt-get update",
    refreshonly => true,
  }
  ->
  package {['jenkins']:}



 $tomcat_version = "7.0.55"

  file { ['/scratch','/scratch/usr','/scratch/usr/local']:
    ensure => directory;
  }
  -> 
  exec {'download-tomcat':
    command => "/usr/bin/wget -O /usr/local/apache-tomcat-${tomcat_version}.tar.gz http://mirror.ox.ac.uk/sites/rsync.apache.org/tomcat/tomcat-7/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz",
    creates => "/usr/local/apache-tomcat-${tomcat_version}.tar.gz",
  }
  ->
  exec {'unpack-tomcat': 
    command => "/bin/tar xzf /usr/local/apache-tomcat-${tomcat_version}.tar.gz",
    cwd => '/usr/local',
    creates => "/usr/local/apache-tomcat-${tomcat_version}",
  }
  -> 
  exec { 'move tomcat': 
    command => "/bin/mv /usr/local/apache-tomcat-${tomcat_version} /scratch/usr/local/",
    creates => "/scratch/usr/local/apache-tomcat-${tomcat_version}",
  } 
  -> 
  exec { 'link to moved tomcat': 
    command => "/bin/ln -s /scratch/usr/local/apache-tomcat-${tomcat_version} /usr/local/tomcat",
    creates => "/usr/local/tomcat",
  }
  -> 
  exec { 'link to tomcat init': 
    command => "/bin/ln -s /usr/local/tomcat/bin/catalina.sh /etc/init.d/tomcat",
    creates => "/etc/init.d/tomcat",
  }
  -> 
  exec { 'link to tomcat logs': 
    command => "/bin/ln -s /usr/local/tomcat/logs /var/log/tomcat",
    creates => "/var/log/tomcat",
  }


  $maven_version = "3.2.2"
  exec {'download-maven':
    command => "/usr/bin/wget -O /usr/local/apache-maven-${maven_version}.tar.gz http://mirror.ox.ac.uk/sites/rsync.apache.org/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz",
    creates => "/usr/local/apache-maven-${maven_version}.tar.gz",
  }
  ->
  exec {'unpack-maven': 
    command => "/bin/tar xzf /usr/local/apache-maven-${maven_version}.tar.gz",
    cwd => '/usr/local',
    creates => "/usr/local/apache-maven-${maven_version}",
  }
  -> 
  file { '/usr/local/maven':
    ensure => 'link',
    target => "/usr/local/apache-maven-${maven_version}",
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
    target => "/usr/local/gradle-${gradle_version}",
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
    creates => "/usr/local/idea-IU-135.1230",
  }
  -> 
  file { '/usr/local/idea':
    ensure => 'link',
    target => "/usr/local/idea-IU-135.1230",
  }
  -> 
  file { '/usr/local/bin/idea.sh':
    ensure => 'link',
    target => '/usr/local/idea/bin/idea.sh',
  }
  ->
  file { '/usr/share/applications/idea.desktop': 
    content => "
[Desktop Entry]
Name=IntelliJ IDEA
Comment=IntelliJ IDEA IDE
Exec=/usr/local/bin/idea.sh
Icon=/usr/local/idea/bin/idea_CE128.png
Terminal=false
StartupNotify=true
Type=Application
Categories=Development;IDE;
",
  }


  exec {' enable user sites': 
    command => "/usr/sbin/a2enmod userdir", 
  }
   

  exec { ' ensure ability to use usb video': 
    command => "/usr/sbin/usermod -G video timp",
  }

}

# Setup ssd
# mv .cache /scratch/home/timp/cache
# ln -s /scratch/home/timp/cache .cache
#
# mv scratch/git /scratch/home/timp/
# mv scratch/bbm /scratch/home/timp/

