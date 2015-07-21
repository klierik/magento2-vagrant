# What is that?
Magento2-vagrant — ultra light Vagrant development environment for running Magento2 CMS, based on Ubuntu Trusty 64.
I create this repo for my self as easyest way install Magento2 and share with you.

Note: *If you are looking Vagrant environment for Magento 1 see [Simple-Magento-Vagrant](https://github.com/klierik/simple-magento-vagrant)*

# What do i get?
+ Ubuntu 14.04 LTS + Apache 2.4 + Php 5.6 + MySQL 5.6
+ Magento2 with latest sample data

After installation you will get clean Magento 2 with latest sample data. 

# Requirements
+ [VirtualBox](https://www.virtualbox.org/wiki/Downloads) — VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use.
+ [Vagrant](http://www.vagrantup.com/downloads.html) — Vagrant is a tool for building complete development environments.
+ [Vagrant Host Manager](https://github.com/smdahlen/vagrant-hostmanager) and [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
+ [Git](https://git-scm.com/downloads) — Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

# Vagrant configuration
In `Vagrantfile` you can find all configuration like ip-address or domain name. By defaults:

**Domain:** [http://magento2-vagrant.dev](http://magento2-vagrant.dev) 

**IP-address:** [192.168.10.10](192.168.10.10) 


# Enable Network File System (NFS)
If your system support NFS open `Vagrantfile` and make changes for `# Synced folder` section

**Windows users:** *NFS folders do not work on Windows hosts. Vagrant will ignore your request for NFS synced folders on Windows.*

# Step-by-step installation
## Step 1 — Get your Magento2-vagrant copy
First of all [download](https://github.com/klierik/magento2-vagrant/archive/master.zip) this repo copy as zip archive (you will need git for clone magento2 repo) and unpack to your `project_folder/`.

Move all folders and files to `project_folder/` root so you will get something like that:
```
$ tree
.
├── LICENSE
├── README.md
└── vagrant
    ├── Vagrantfile
    └── bootstrap.sh
```

## Step 2 — clone Magento2
Go to your `project_folder/` and clone [Magento2](https://github.com/magento/magento2) repo via command line:
```
$ cd /path/to/project_folder/
$ git clone git@github.com:magento/magento2.git
Cloning into 'magento2'...
remote: Counting objects: 705361, done.
remote: Compressing objects: 100% (1203/1203), done.
remote: Total 705361 (delta 640), reused 0 (delta 0), pack-reused 703896
Receiving objects: 100% (705361/705361), 203.98 MiB | 2.38 MiB/s, done.
Resolving deltas: 100% (398225/398225), done.
Checking connectivity... done.
Checking out files: 100% (22099/22099), done.
```

and your project folders structure now like:
```
$ tree -L 2
.
├── LICENSE
├── README.md
├── magento2
│   ├── CHANGELOG.md
│   ├── CONTRIBUTING.md
│   ├── CONTRIBUTOR_LICENSE_AGREEMENT.html
│   ├── COPYING.txt
│   ├── Gruntfile.js
│   ├── LICENSE.txt
│   ├── LICENSE_AFL.txt
│   ├── README.md
│   ├── app
│   ├── bin
│   ├── composer.json
│   ├── composer.lock
│   ├── dev
│   ├── index.php
│   ├── lib
│   ├── nginx.conf.sample
│   ├── package.json
│   ├── php.ini.sample
│   ├── pub
│   ├── setup
│   └── var
├── magento2-vagrant-master.zip
└── vagrant
    ├── Vagrantfile
    └── bootstrap.sh
```

## Step 3 — Vagrant Guest-OS installation
Open you `project_folder/vagrant/` and run `vagrant up` to install:
```
$ cd /path/to/project_folder/vagrant/
$ vagrant up
Bringing machine 'magento2-vagrant' up with 'virtualbox' provider...
==> magento2-vagrant: Importing base box 'trusty64'...
==> magento2-vagrant: Matching MAC address for NAT networking...
...
...
...
==> magento2-vagrant: Reading package lists...
==> magento2-vagrant: Building dependency tree...
==> magento2-vagrant: Reading state information...
==> magento2-vagrant: ==================================================
==> magento2-vagrant: ============= INSTALLATION COMPLETE ==============
==> magento2-vagrant: ==================================================
```
it will install Ubuntu + Apache + PHP + Composer (and magento dependencies).

Now open `project_folder/vagrant` and run `$ vagrant_ssh`. When you login to Ubuntu tun commands:
```
$ cd /vagrant/httpdocs/
$ composer install
```
and wait while all composer download all modules.
If system will ask you a Token:
```
Could not fetch https://api.github.com/repos/sebastianbergmann/php-timer/zipball/83fe1bdc5d47658b727595c14da140da92b3d66d, please create a GitHub OAuth token to go over the API rate limit
Head to https://github.com/settings/tokens/new?scopes=repo&description=Composer+on+magento2-vagrant+2015-07-21+1424
to retrieve a token. It will be stored in "/home/vagrant/.composer/auth.json" for future use by Composer.
Token (hidden):
```
go to you [github account](https://github.com/settings/tokens), generate the new one and past. After this system says:
```
Token stored successfully.
```

## Step 4 — Install MySQL manually
Now go to `project_folder/vagrant/` and run command
```
$ vagrant ssh
Welcome to Ubuntu 14.04.2 LTS (GNU/Linux 3.13.0-55-generic x86_64)
...
...
```

If you something like before it's mean everything is fine so let's install MySQL (i don't know how to install it in silent mode but if yoo know how please share with us).

Now run commands:
```
$ sudo apt-get install mysql-server-5.6 mysql-client-5.6 && mysql_secure_installation
$ sudo apt-get -y autoremove && sudo apt-get -y autoclean
```

Thought installation MySQL command lime will ask you some questions [Y/n] so enter `Y` and press enter. When you will see window with password for MySQL server enter password (remember it).
And after that `mysql_secure_installation` will ask you about some question too so configure it, example:
```
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MySQL
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MySQL to secure it, we'll need the current
password for the root user.  If you've just installed MySQL, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MySQL
root user without the proper authorisation.

You already have a root password set, so you can safely answer 'n'.

Change the root password? [Y/n] n
 ... skipping.

By default, a MySQL installation has an anonymous user, allowing anyone
to log into MySQL without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] n
 ... skipping.

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] n
 ... skipping.

By default, MySQL comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] y
 - Dropping test database...
ERROR 1008 (HY000) at line 1: Can't drop database 'test'; database doesn't exist
 ... Failed!  Not critical, keep moving...
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] y
 ... Success!




All done!  If you've completed all of the above steps, your MySQL
installation should now be secure.

Thanks for using MySQL!


Cleaning up...
```

Perfect! Now let's enter to MySQL and create database:
```
$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 48
Server version: 5.6.19-0ubuntu0.14.04.1 (Ubuntu)

Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database magento;
Query OK, 1 row affected (0.00 sec)

mysql> GRANT ALL ON magento.* TO magento@localhost IDENTIFIED BY 'magento';
Query OK, 0 rows affected (0.00 sec)

mysql> exit
Bye
```

## Step 5 — Magento2 installation
Open browser and go [http://magento2-vagrant.dev/setup/](http://magento2-vagrant.dev/setup/)

### Magento2 Installation step 0 — Agree and Setup Magento
Just press **Agree and Setup Magento** button

### Magento2 Installation step 1 — Readiness Check
Press **Start Readiness Check** button and wait for checking. 

After finish system says *Completed! You can now move on to the next step.* and you can press **Next** button.

### Magento2 Installation step 2 — Add a Database
Here you just need enter your database password that you already enter at **Step 4 — Install MySQL manually** and press **Next** button.

### Magento2 Installation step 3 — Web Configuration
There is nothing to say because here as usual everything is fine by default so press **Next** button.
 
### Magento2 Installation step 4 — Customize Your Store
Here you can edit timezone, currency and language options. At this step *Sample Data* checkbox should be disabled (we will install it via command line because via web-interface system show error). Also you can check/uncheck some modules at **Advanced Modules Configurations** collapse.
When you finis just press **Next** button.
 
### Magento2 Installation step 5 — Create Admin Account
It's easy — just enter all data and press **Next** button

### Magento2 Installation step 6 — Install/Success
You're ready! Press **Install Now** button and wait while installation complete (5-10 min depends of your computer performance).

When you will see **Success** page system will tell you **Your Store Address:** [http://magento2-vagrant.dev/](http://magento2-vagrant.dev/), **Magento Admin Address:** [http://magento2-vagrant.dev/admin/](http://magento2-vagrant.dev/admin/) and other important information.
Perfect, it is work! Now install Sample Data.

## Step 6 — Magento2 sample data installation
Go to `project_folder/vagrant/` and run `vagrant ssh`. Then run commands:
```
$ cd /vagrant/httpdocs
$ composer config repositories.magento composer http://packages.magento.com
```

Then `require` latest sample data version that you can find here: [http://packages.magento.com/#!/magento/module-sample-data](http://packages.magento.com/#!/magento/module-sample-data), for example:
```
$ composer require magento/sample-data:1.0.0-beta
./composer.json has been updated
Loading composer repositories with package information
Updating dependencies (including require-dev)
  - Installing magento/sample-data-media (0.42.0-beta2)
    Downloading: 100%         

  - Installing magento/module-sample-data (1.0.0-beta)
    Downloading: 100%         

Writing lock file
Generating autoload files
```

Sample data now downloaded and you need install it. Run:
```
$ cd /vagrant/httpdocs/bin/
$ $ php magento setup:upgrade
  Cache cleared successfully
  File system cleanup:
  /vagrant/httpdocs/var/generation/Magento
  Updating modules:
  Schema creation/updates:
  Module 'Magento_Store':
  ...
  ...
  ...
  Module 'Magento_Wishlist':
```

and after update run next command and wait 5-10 min (depends of your computer performance) while installation complete:
```
$ php magento sampledata:install admin
Installing theme:
.
Installing customers:
sh: 1: /usr/sbin/sendmail: not found
.
Installing CMS pages:
....
Installing catalog attributes:
........
Installing categories:
........
Installing simple products:
........
Installing bundle products:
.
Installing downloadable products:
......
Installing grouped products:
.
Installing configurable products:
...............
Installing Tablerate:
.........
Installing taxes:
..
Installing CMS blocks:
..................
Installing product links:
.............
Installing orders:
..
Installing sales rules:
....
Installing product reviews:
...........
Installing catalog rules:
.
Installing wishlists:
.
Installing Widgets:
..................Successfully installed sample data.
```

Sample data installed so now you need run `LESS -> CSS` builder:
```
$ php magento dev:css:deploy less css/styles-l --locale="en_US" --area="frontend" --theme="Magento/blank"
Gathering css/styles-l.less sources.
Successfully processed LESS and/or SASS files
$ php magento dev:css:deploy less css/styles-l --locale="en_US" --area="frontend" --theme="Magento/luma"
Gathering css/styles-l.less sources.
Successfully processed LESS and/or SASS files
```
That's it. Now you need just reset cache in `Admin panel -> System -> Cache Management`:
* Flush Magento Cache
* Flush JavaScript/CSS Cache
* Select all cache types and Refresh it

# Troubleshooting
## Problem with skin styles (less to css compile)
If you have problem with front-end view with broken styles read this solution: [Magento2 + Magento/blank + Magento/luma + broken styles](https://github.com/magento/magento2/issues/1525) 

I wish you luck :)
