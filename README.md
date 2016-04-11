# What is that?
Magento2-vagrant — ultra light Vagrant development environment for running Magento2 CMS, based on Ubuntu Trusty 64.
I create this repo for my self as easyest way install Magento2 and share with you.

Note: *If you are looking Vagrant environment for Magento 1 see [Simple-Magento-Vagrant](https://github.com/klierik/simple-magento-vagrant)*

# What do i get?
+ Ubuntu 14.04 LTS + Apache 2.4 + Php 5.6 + MySQL 5.6
+ Magento2 with latest sample data

After installation you will get clean Magento 2 with latest sample data.

# Requirements
+ [VMware Fusion](https://www.vmware.com/products/fusion) — VMware Fusion is a software hypervisor developed by VMware for computers running OS X with Intel processors. For [VirtualBox](https://www.vmware.com/products/fusion) version please look [1.0.0-virtualbox](https://github.com/klierik/magento2-vagrant/tree/1.0.0-virtualbox) branch.
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
Bringing machine 'magento2-vagrant' up with 'vmware_fusion' provider...
==> magento2-vagrant: Cloning VMware VM: 'trusty64'. This can take some time...
==> magento2-vagrant: Verifying vmnet devices are healthy...
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

The script automatically generates a root password for the MySQL installation.  Look for it in the output of `vagrant up`; e.g.:

```
########################################################"
# Your MySQL root password is: ohpifioyeo
########################################################"
```

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

## Step 4 — Magento2 installation
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

## Step 5 — Magento2 sample data installation
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

# Changelog
All notable changes to this project will be documented in this section

## [1.0.0] - 2016-01-15
### Init
Init stable release based on [VMware Fusion](https://www.vmware.com/products/fusion).

I wish you luck :)
