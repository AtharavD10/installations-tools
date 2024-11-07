    #Initial Steps

    1  sudo apt update
    2  sudo apt upgrade
    3  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    4  wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null
    5  sudo apt update
    6  sudo apt-get -y install postgresql postgresql-contrib
    7  sudo systemctl enable postgresql
    8  sudo passwd postgres
    9  su - postgres
   10  apt install openjdk-17-jre-headless -y
   11  echo "sonarqube   -   nofile   65536" | sudo tee -a /etc/security/limits.conf
   12  echo "sonarqube   -   nproc    4096" | sudo tee -a /etc/security/limits.conf
   13  echo "vm.max_map_count = 262144" | sudo tee -a /etc/sysctl.conf

   # system restart

   14  init 6

   # rest command set

   15  sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
   16  sudo apt install unzip
   17  sudo unzip sonarqube-9.9.0.65466.zip -d /opt
   18  sudo mv /opt/sonarqube-9.9.0.65466 /opt/sonarqube
   19  sudo groupadd sonar
   20  sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar
   21  sudo chown sonar:sonar /opt/sonarqube -R
   22  cd /opt/sonarqube/conf/

  Updating sonar properties
   
   23  vi sonar.properties

   # User credentials.
    # Permissions to create tables, indices and triggers must be granted to JDBC user.
    # The schema must be created first.
    sonar.jdbc.username=sonar
    sonar.jdbc.password=sonar 

    #----- PostgreSQL 11 or greater
    # By default the schema named "public" is used. It can be overridden with the parameter "currentSchema". (Use Same URL for this)
    sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
   
    # Creating Service File 
   
   25  vim /etc/systemd/system/sonar.service

[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target

# Now start Sonar service 

   26  sudo systemctl start sonar
   27  sudo systemctl enable sonar
   28  sudo systemctl status sonar
   29  tail -f /opt/sonarqube/logs/sonar.log
