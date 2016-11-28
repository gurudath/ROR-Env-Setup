#!/bin/bash
#
# Rails Ready
#
# Author: Gurudath BN <gurudath.1989@gmail.com>
# Licence: MIT
#
#
ruby_source_dir_name="ruby-2.2.3"
gemset_name = 'rails4rubynew'
export GURUCODB=gurudath
export GURUCOUSER=gurudath

pm="apt-get"
clear
echo "#################################"
echo "########## Ruby On Rails Installation Begining ##########"
echo "#################################"
echo -e "\n"
echo "##### Please provide system password to install packages and move further ############################"
# Check if the user has sudo privileges.
#sudo -v >/dev/null 2>&1 || { echo $script_runner has no sudo privileges ; exit 1; }
echo -e "\n"
echo "##### Updating the system packages ############################"
sudo apt-get update
echo -e "\n=> Installing build tools..."
sudo $pm -y install \
    wget curl build-essential clang \
    bison openssl zlib1g \
    libxslt1.1 libssl-dev libxslt1-dev \
    libxml2 libffi-dev libyaml-dev \
    libxslt-dev autoconf libc6-dev \
    libreadline6-dev zlib1g-dev libcurl4-openssl-dev \
    libtool
echo "==> done..."
echo -e "\n=> Installing libs needed for sqlite, mysql and postgresql..."
sudo $pm -y install libsqlite3-0 sqlite3 libsqlite3-dev libmysqlclient-dev libpq-dev
echo "==> done..."
# Install git-core
echo -e "\n=> Installing git..."
sudo $pm -y install git-core
echo "==> done..."
echo -e "\n=> Installing Bundler, Passenger and Rails..."
sudo gem install bundler passenger rails
echo "##### Generate the keyserver for ruby instllation ############################"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
echo "##### Get stabled ruby version ############################"
\curl -sSL https://get.rvm.io | bash -s stable --ruby
echo "##### ruby version ############################"
echo "==> done..."
echo "=> Loading RVM..."
if [ -f ~/.profile ] ; then
source ~/.profile
fi
if [ -f ~/.bashrc ] ; then
source ~/.bashrc
fi
if [ -f ~/.bash_profile ] ; then
source ~/.bash_profile
fi
if [ -f /etc/profile.d/rvm.sh ] ; then
source /etc/profile.d/rvm.sh
fi
echo "==> done..."
echo -e "\n=> Installing Ruby $ruby_version_string (this will take a while)..."
rvm install $ruby_source_dir_name
echo -e "\n########$ruby_source_dir_name installed #########################"
echo -e "\n########$ruby_source_dir_name iniciating #########################"
rvm use $ruby_source_dir_name
echo -e "\n########$gemset_name creating gemset #########################"
rvm gemset create $gemset_name
echo "==> done..."
echo -e "\n#################################"
echo    "### Installation is complete! ###"
echo "--------------------------------------------"
echo "This script will install PostgreSQL."
echo "--------------------------------------------"
sudo apt-get install postgresql postgresql-contrib libpq-dev
read -e -p "Install PostgreSQL database? [y/n] " -i "n" installpg
if [ "$installpg" = "y" ]; then
  sudo apt-get install postgresql
  echo
  echo "You will now set the default password for the postgres user."
  echo "This will open a psql terminal, enter:"
  echo
  echo "\\password postgres"
  echo
  echo "and follow instructions for setting postgres admin password."
  echo "Press Ctrl+D or type \\q to quit psql terminal"
  echo "START psql --------"
  sudo -u postgres psql postgres
  echo "END psql --------"
  echo
fi
read -e -p "Create gurudath Database and user? [y/n] " -i "n" createdb
if [ "$createdb" = "y" ]; then
  sudo -u postgres createuser -D -A -P $GURUCOUSER
  sudo -u postgres createdb -O $GURUCOUSER $GURUCODB
  echo
fi
echo
echo "You must update postgresql configuration to allow password based authentication"
echo
echo "After you have updated, restart the postgres server /etc/init.d/postgresql restart"
sudo /etc/init.d/postgresql reload
echo
echo -e "####### Ruby On Rails with postgres Installation End ##########################\n"
echo -e "\n Thanks you ! Gurudath BN\n"




