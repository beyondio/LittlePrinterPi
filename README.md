# LittlePrinterPi

### Description
Multiple ways to set up a Raspberry Pi that includes a working installation of [Sirius](https://github.com/genmon/sirius), the alternative backend / cloud component for your BERG Cloud Little Printer.

### Installing a barebones Sirius on a Raspberry Pi

#### Options
You can either:

1. Install the pre-made image: pick this if you just want start printing again.  At the moment you can log in with Twitter and send messages to your Little Printer.
2. Use the install script: pick this if you want a working Sirius installation which you can use to further explore and develop Sirius. The script sets up a virtualenv which makes it easier to work in.
3. Explore the script and manually follow all the steps.  Use this if you know what you're doing or want to set up something specific.  The install script should work -caveat emptor- on any debian based linux distribution, but you will have to install the appropriate PhantomJS as described [here](https://gist.github.com/hako/f8944cfa7b8fb8115f6d#installing-phantomjs).

#### Needed in any case:

- Raspberry Pi (including power supply and ethernet cable)
- SD card - at least 2GB for the pre-made image
- An SD card reader on your PC
- A Little Printer
- A BERG Cloud Bridge

#### The easy way: flash an SD card with the pre-made image:

For everyone who just wants to get Sirius running and not change anything afterwards.
This image works fine on an original Raspberry Pi, if you have a Raspberry Pi 2 it's recommneded to use the install script.

Download and flash [this image](https://github.com/beyondio/LittlePrinterPi/releases/download/v0.1-alpha.1/LPPI_SIRIUS_v0.1-alpha.1.img.zip) to your SD card.
Boot the Raspberry Pi.

Defaul login details : `ssh -l root littleprinterpi.local` to connect to your Pi.
Username : `root`
Password : `raspbian`

Recommended :
run `passwd` to set a different password.
run `dpkg-reconfigure tzdata` to configure your timezone

Optional :
You can run `raspi-config` if you want to expand your filesystem to use the full capacity of the SD card and to overclock your Raspberry Pi.  
You will be asked to reboot for the changes to take effect.

Sirius should start on boot and you should be able access it at

`http://littleprinterpi.local:5000/`

Now you can follow [hako's guide](https://gist.github.com/hako/f8944cfa7b8fb8115f6d#step-5) from Step 5 and onwards to connect your Little Printer to you LittePrinterPi and start printing.

#### A lot more time consuming: the install script

##### Let's first get a barebones Raspbian on to the SD card.  

You can of course install another flavour of Linux on your Raspberry Pi if you prefer, but these instructions will assume Raspbian.
- Download the latest release : https://github.com/debian-pi/raspbian-ua-netinst/releases/latest
- Unzip the downloaded file
- Insert and format your SD card as FAT32 (MS-DOS on Mac OS X) and extract the installer files in the root of the freshly formatted filesystem.
- Insert the SD card from your PC into your Raspberry Pi. You can just power on your Pi and cross your fingers.  The activity LED shoud start blinking
- Wait for about 15 minutes, while Raspbian downloads and installs itself
- Find out the IP address of your Raspberry Pi
- Login via SSH : ssh -l root <raspberry ip address>  and use the default password "raspbian"
- Set new root password: passwd
- Configure your default locale: dpkg-reconfigure locales
If you get these annoying perl: warning: Setting locale failed errors. `nano /etc/default/locale` and add `LANGUAGE=en_US:en` & `LC_ALL=en_US.UTF-8` lines to the file.  Or the locale of your chosing.
You  might need to reboot for these errors to stop now.
- Configure your timezone: `dpkg-reconfigure tzdata`
- Optional: apt-get install raspi-copies-and-fills for improved memory management performance.
- Optional : apt-get install raspi-config && raspi-config if you want to expand your filesystem to use the full capacity of the SD card and to overclock your Raspberry Pi.  You will be asked to reboot for the changes to take effect
- Recommened : install nano editor : apt-get install nano (or alternatively use editor or pico)
- Let's set a hostname : `nano /etc/hosts`  and change `127.0.1.1 pi` into `127.0.1.1 LittlePrinterPi` (or whatever you like).  And `nano /etc/hostname` to change `pi` to `LittlePrinterPi` , finally do `sh /etc/init.d/hostname.sh`
If you want to use a simple domain name like `litteprinterpi.local` do a `apt-get install avahi-daemon`  This way, we won't have to try to find out the Pi's new IP address when it changes.

##### Now let's use the install script to get everything up and running:

```
wget https://github.com/beyondio/LittlePrinterPi/releases/download/v0.1-alpha.1/LittlePrinterPi.sh -N -P /tmp/ && source /tmp/LittlePrinterPi.sh && rm /tmp/LittlePrinterPi.sh
```

The script will install Sirius in `/opt/sirius`

This will take ... ages ... and will show lots of warnings, which we'll ignore for now.  
When the script is finished, it will ask to delete itself.

##### Starting Sirius

Contrary to the pre-made image, Sirius will not start on boot.
To get it up and running do:
```
cd $SIRIUS_PATH
```
```
workon lpenv
```
```
honcho start
```

What you should see:
```
web.1  | [2016-01-19 06:17:55 +0000] [42169] [INFO] Starting gunicorn 19.1.1
web.1  | [2016-01-19 06:17:55 +0000] [42169] [INFO] Listening at: http://0.0.0.0:5000 (42169)
web.1  | [2016-01-19 06:17:55 +0000] [42169] [INFO] Using worker: flask_sockets.worker
web.1  | [2016-01-19 06:17:55 +0000] [42172] [INFO] Booting worker with pid: 42172
web.1  | --------------------------------------------------------------------------------
web.1  | DEBUG in webapp [<path>]:
web.1  | Creating app.
web.1  | --------------------------------------------------------------------------------
web.1  | DEBUG:sirius.web.webapp:Creating app.
web.1  | DEBUG:geventwebsocket.handler:Initializing WebSocket
web.1  | DEBUG:geventwebsocket.handler:Validating WebSocket request
```

Now you can follow [hako's guide](https://gist.github.com/hako/f8944cfa7b8fb8115f6d#step-5) from Step 5 and onwards to connect your Little Printer to you LittePrinterPi and start printing.

### Credits

- [Matt Web](https://github.com/genmon/) for providing a lifeline for our Little Printers aka [Sirius](https://github.com/genmon/sirius).
- [Hako](https://github.com/hako) for this [great guide](https://gist.github.com/hako/f8944cfa7b8fb8115f6d) upon which these image and scripts are largely based.
