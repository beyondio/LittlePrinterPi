#!/bin/sh
echo 'Installing sirius - alternative backend for the Little Printer'
echo 'This might take a while ...'
LIST_OF_APPS="git python-pip libpq-dev libfreetype6-dev fontconfig libgstreamer0.10-dev python-dev" #List of prerequisite
SIRIUS_PATH="/opt/sirius" #Set installation path for Sirius
export SIRIUS_PATH=$SIRIUS_PATH #To make sure we keep track where sirius was installed
echo 'SIRIUS_PATH='$SIRIUS_PATH >> /etc/environment #Make the sirius path an environment variable
echo 'Getting latest package lists'
apt-get update && apt-get install apt-transport-https -y  # To get the latest package lists and make sure we can handle https mirrors
echo 'Installing prerequisite'
apt-get install $LIST_OF_APPS -y #installing all the prerequisites
echo 'Downloading PhantomJS binary for ARM'
wget https://github.com/piksel/phantomjs-raspberrypi/raw/master/bin/phantomjs -N -P /usr/local/bin #fetching the phantomjs ARM binary
echo 'Making PhantomJS binary executable'
chmod 755 /usr/local/bin/phantomjs #make phantomjs binary executable
echo 'Installing Honcho via pip'
pip install honcho
pip install virtualenv virtualenvwrapper
echo 'export WORKON_HOME=~/Envs' >>~/.bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >>~/.bashrc
source ~/.bashrc
mkdir -p $WORKON_HOME
mkvirtualenv lpenv
workon lpenv
echo 'Cloning the sirius GIT repo'
git clone https://github.com/genmon/sirius.git $SIRIUS_PATH
echo 'Installing all the required packages for sirius via pip'
pip install -r $SIRIUS_PATH/requirements.txt
echo 'Upgrading the sirius Postsql database'
python $SIRIUS_PATH/manage.py db upgrade
echo 'ALL DONE!'
echo 'To start sirius via honcho try :'
echo 'cd $SIRIUS_PATH && honcho -e $SIRIUS_PATH/.env -d $SIRIUS_PATH/ -f $SIRIUS_PATH/Procfile start'
echo 'After boot, make sure to initialize the virtual environment with "workon lpevn"'
